import 'package:chat_apps/app/utils/ErrorPage.dart';
import 'package:chat_apps/app/utils/LoadingPage.dart';
import 'package:chat_apps/app/utils/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        
        if (snapshot.hasError) { //jika koneksi errror
          return ErrorPage();
        }

        if (snapshot.connectionState == ConnectionState.done) { //jika koenksinya berhasil maka jalankan future builder dulu
          return FutureBuilder( //future builder disini untuk menjalankan splashscreen
            future: Future.delayed(Duration(seconds: 3)), //splashscreen akan muncul selama 3 detik
            builder: (context, snapshot) { 
              if (snapshot.connectionState == ConnectionState.done) { //jika future builder selesai dijalankan maka jalankan HomeView
                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: "Application",
                  initialRoute: AppPages.INITIAL,
                  getPages: AppPages.routes,
                );
              }
              return Splashscreen(); //jika future builder belum selesai dijalankan maka jalankan splashscreen
            },
          );
        }

        return Loadingpage();
      },
    ),
  );
}
