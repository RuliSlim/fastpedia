import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Syarat extends StatefulWidget {
  @override
  _Syarat createState() => _Syarat();
}

class _Syarat extends State<Syarat> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Syarat dan Ketentuan",
          style: TextStyle(
              color: Hexcolor("#FFFFFF"),
              fontSize: 20,
              fontWeight: FontWeight.w700
          ),
        ),
        centerTitle: false,
        backgroundColor: Hexcolor("#4EC24C"),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: AutoSizeText(
              """
1.Definisi
1.A Aplikasi Fastpedia adalah aplikasi perangkat lunak yang menyediakan layanan edukasi digital, yang dapat
digunakan oleh masyarakat umum.


2.Pendaftaran Akun
2.A Sebelum pengguna menggunakan Aplikasi Fastpedia, pengguna diwajibkan untuk melakukan pendaftaran melalui Aplikasi Fastpedia. Pengguna diwajibkan mengisi data Nama sesuai dengan identitas diri, Email, NIK, Nomor Telepon, Nama Pengguna, dan Password.

2.B Dengan mendaftar di Aplikasi Fastpedia, pengguna telah menyetujui semua kebijakan yang telah ditetapkan oleh developer Aplikasi Fastpedia

2.C Perubahan data hanya untuk memperbaharui informasi sesuai dengan akurasi data yang dimiliki pengguna. Perubahan data hanya bisa dilakukan untuk perubahan data Email, Nomor Telepon, dan Password.

2.D Pengguna dilarang untuk mengungkapkan informasi login kepada pihak ketiga atau manapun. Developer Aplikasi Fastpedia tidak pernah meminta informasi data login pengguna melalui media cetak maupun elektronik

2.E Pengguna dilarang untuk memperjual belikan akun kepada pihak ketiga atau pihak manapun.


3. Ketentuan Penggunaan Aplikasi
3.A Fastpedia memberikan beberapa layanan, diantaranya Mining Ads, History, Wallet, dan Transfer Scan Barcode.

3.B Layanan tersebut dapat berubah dari waktu ke waktu, selama developer aplikasi memperbaharui, memperbaiki, memodifikasi, dan menambahkan fitur pada Aplikasi Fastpedia.

3.C Pengguna dapat menggunakan layanan tersebut ketika pengguna telah berhasil dan terdaftar pada Aplikasi Fastpedia.

3.D Pengguna wajib menginformasikan kepada kami, jika pengguna tidak lagi memiliki kontrol terhadap akun Aplikasi Fastpedia, atau terkait peretasan (Hack Acccount), sehingga kami dapat membekukan akun pengguna sampai benar-benar kami memverifikasi kebenaran akun yang dimiliki.

3. EPada fitur Mining Ads, anda diwajibkan Menonton dan Men-Subcribe pengguna lainnya. Pengguna akan diminta untuk melakukan login akun Youtube.

3.F Login akun Youtube telah kami buat secara penghubungan langsung antara Youtube dengan Pengguna

3.G Pengguna telah mengatahui, bahwa Developer Aplikasi tidak pernah mengetahui segala aktifitas Akun Youtube pengguna setelah melakukan Login Akun Youtube yang dilakukan pada Aplikasi Fastpedia.


4. Tanggung Jawab
4.A Pengguna bertanggung jawab atas segala aktifitas pada Aplikasi Fastpedia, meskipun akun tersebut disalahgunakan oleh orang lain

4.B Pengguna bertanggung jawab atas akurasi data yang di isi oleh pengguna, pada "Form Register" Aplikasi Fastpedia.

4.C Pengguna bertanggung jawab atas kelangsungan aktivasi akun yang terhubung dengan pihak ketiga pada aplikasi Fastpedia

5. Ganti Rugi
5.A Dengan melakukan pendaftaran pada Aplikasi Fastpedia, pengguna telah mengetahui dan menyetujui bahwa Developer Aplikasi Fastpedia tidak bertanggung jawab terhadap aktivasi dan pemblokiran akun Youtube diluar kendali Developer Aplikasi Fastpedia.
          """,
              style: TextStyle(
                  color: Colors.black
              ),
              maxFontSize: 20,
              minFontSize: 16,
            ),
          )
      ),
    );
  }

}