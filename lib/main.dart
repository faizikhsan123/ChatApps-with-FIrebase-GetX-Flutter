import 'package:chat_apps/app/controllers/auth_c_controller.dart';
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

  final authC = Get.put( AuthCController(),permanent: true,
  ); //import auth_c_controller di set permanent karena akan digunakan di seluruh aplikasi
  runApp(
    FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorPage();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: Future.delayed(Duration(microseconds: 1)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Obx(
                  //karena ada data yg di pantau (obs) maka kita pake obx
                  () => GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: "Chat Apps",
                    initialRoute: authC.skipIntro.isTrue //kalo skipIntro bernilai true trs di cek lagi sama yg dibawah
                        ? authC.isAuth.isTrue //kalo suda login dia ke home kalo belum ke login
                              ? Routes.HOME
                              : Routes.LOGIN //ini kalo skipitro bernilai true tetapi dia bblm login langsung ke login
                        : Routes .PROFILE, //ini kalo skipIntro bernilai false langsung ke introduction
                    getPages: AppPages.routes,
                  ),
                );
              }
              return Splashscreen();
            },
          );
        }

        return Loadingpage();
      },
    ),
  );
}
