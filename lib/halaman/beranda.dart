import 'package:flutter/material.dart';

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beranda'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selamat Datang di Aplikasi Kami!',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika navigasi ke halaman lain di sini
              },
              child: Text('Tombol Navigasi'),
            ),
          ],
        ),
      ),
    );
  }
}
