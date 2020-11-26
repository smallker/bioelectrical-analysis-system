#include <Arduino.h>
#include <LiquidCrystal_I2C.h>
#include <Keypad.h>
#include <SoftwareSerial.h>
#include <TimerOne.h>
#define RX_ARD 3
#define TX_ARD 2

SoftwareSerial node(3, 2);
LiquidCrystal_I2C lcd(0x27, 16, 2);
const byte ROWS = 4; //four rows
const byte COLS = 3; //three columns
char keys[ROWS][COLS] = {
    {'1', '2', '3'},
    {'4', '5', '6'},
    {'7', '8', '9'},
    {'*', '0', '#'}};
byte rowPins[ROWS] = {5, 6, 7, 8};
byte colPins[COLS] = {9, 10, 11};
Keypad kpd = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);
unsigned long loopCount = 0;
unsigned long timer_t = 0;
char buff[5];
int count;
char key;
volatile bool sent;
void readKeypad()
{
  key = kpd.getKey();
  if(key == '#') sent = true;
}
void setup()
{
  Serial.begin(9600);
  node.begin(9600);
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("No. Pasien :");
  kpd.setDebounceTime(50);
  Timer1.initialize(1000);
  Timer1.attachInterrupt(readKeypad);
}
void loop()
{
  if (key && key != '#')
  {
    buff[count] = key;
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("No. Pasien :");
    lcd.setCursor(0, 1);
    lcd.print(buff);
    count++;
  }
  if (sent)
  {
    node.print(buff);
    lcd.clear();
    lcd.print("Tunggu . .");
    while (true)
    {
      if (node.available() > 0)
      {
        String data = node.readStringUntil(13);
        if (data.length() > 0)
        {
          lcd.clear();
          lcd.print(data);
          delay(1000);
          break;
        }
      }
    }
    count = 0;
    for (int i = 0; i < 5; i++)
    {
      buff[i] = 0;
    }
    lcd.clear();
    lcd.print("Frekuensi :");
    sent = false;
  }
}