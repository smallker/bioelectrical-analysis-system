import 'dart:async';
import 'dart:html';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/pixel.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int nomorPasien = 0;
  String nama = 'nama pasien';
  int berat = 0;
  int tinggi = 0;
  int usia = 0;
  int gender = 0;
  double ecw = 0;
  double tbw = 0;
  int modified = 0;

  fetchData() async {
    var response = await http.get('http://localhost:3000/last');
    if (response.statusCode == HttpStatus.ok) {
      var body = response.body;
      var data = json.decode(body);
      setState(() {
        nomorPasien = data['no_pasien'];
        nama = data['nama'];
        berat = data['berat'];
        tinggi = data['tinggi'];
        usia = data['usia'];
        gender = data['jenis_kelamin'];
        ecw = data['ecw'];
        tbw = data['tbw'];
      });
    }
  }

  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (_) async => fetchData());
  }

  Widget _info() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(View.blockX * 1),
        child: ListView(
          children: [
            CustomCard(
              icon: Icon(
                Icons.confirmation_number,
                size: View.blockX * 4,
                color: Colors.white,
              ),
              title: 'Nomor Pasien',
              subtitle: nomorPasien.toString(),
            ),
            CustomCard(
              icon: Icon(
                Icons.person,
                size: View.blockX * 4,
                color: Colors.white,
              ),
              title: 'Nama Pasien',
              subtitle: nama,
            ),
            CustomCard(
              icon: Icon(
                Icons.accessibility_new,
                size: View.blockX * 4,
                color: Colors.white,
              ),
              title: 'Tinggi',
              subtitle: '$tinggi cm',
            ),
            CustomCard(
              icon: Icon(
                Icons.accessibility_new,
                size: View.blockX * 4,
                color: Colors.white,
              ),
              title: 'Berat',
              subtitle: '$berat kg',
            ),
            CustomCard(
              icon: Icon(
                Icons.article,
                size: View.blockX * 4,
                color: Colors.white,
              ),
              title: 'Usia',
              subtitle: '$usia tahun',
            ),
            CustomCard(
              icon: Icon(
                Icons.person_outline_rounded,
                size: View.blockX * 4,
                color: Colors.white,
              ),
              title: 'Jenis Kelamin',
              subtitle: gender == 0 ? 'Perempuan' : 'Laki-laki',
            ),
          ],
        ),
      ),
    );
  }

  Widget _data(String type, String data) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(View.blockX * 3),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    type,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: View.blockX * 3,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.lightBlue,
                child: Center(
                  child: Text(
                    '$data L',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: View.blockX * 7,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _result() {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _data('TBW', tbw.toString()),
            _data('ECW', ecw.toString()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    View().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bioelectrical Impedance Analysis'),
        ),
        body: Container(
          child: Row(
            children: [
              _info(),
              _result(),
            ],
          ),
        ),
      ),
    );
  }
}
