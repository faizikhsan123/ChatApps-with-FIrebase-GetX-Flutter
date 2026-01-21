import 'package:chat_apps/app/utils/ErrorPage.dart';
import 'package:chat_apps/app/utils/LoadingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async { //tambahkan async
  WidgetsFlutterBinding.ensureInitialized(); //untuk inisialisasi
  await Firebase.initializeApp();//inisialisasi firebase
  runApp(
    FutureBuilder(  //dipakai kalau ada proses ASINKRON (future) dan UI harus nunggu hasilnya sebelum lanjut.
      future: Firebase.initializeApp(), //future nya diambil dari firebase AMPILKAN UI berdasarkan status proses Firebase.initializeApp()
       builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) { //jika koneksi berhasil maka
          return GetMaterialApp(
            title: "Application",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          );
          
        }else if (snapshot.connectionState == ConnectionState.waiting) {
          return Loadingpage(); ///jika koneksi belum selesai maka tampilkan widget loading
        }
        else {
          return ErrorPage(); //jika koneksi gagal maka tampilkan widget error
        }
       
      
    },
    )

   
  );
}
