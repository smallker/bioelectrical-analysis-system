#include <Arduino.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#define RX_NODE   D7
#define TX_NODE   D8
#define SSID      "bolt"
#define PASS      "11111111"

SoftwareSerial data(RX_NODE, TX_NODE);
void setup() {
  Serial.begin(9600);
  data.begin(9600);
  WiFi.begin(SSID, PASS);
}

void loop() {
  if(data.available()>0){
    Serial.println(data.readString());
    delay(5000);
    data.print("Wahyu");
    data.write(13);
  }
}