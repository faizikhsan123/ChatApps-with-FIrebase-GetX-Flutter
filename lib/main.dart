import 'package:chat_apps/app/controllers/auth_c_controller.dart';
import 'package:chat_apps/app/utils/ErrorPage.dart';
import 'package:chat_apps/app/utils/LoadingPage.dart';
import 'package:chat_apps/app/utils/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // untuk menghindari orientasi landscape (agar selalu portrait)
  await Firebase.initializeApp();

  final authC = Get.put(AuthCController(), permanent: true);
  runApp(
    FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorPage();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: Future.delayed(Duration(seconds: 3)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Obx(
                  () => GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: "Chat Apps",
                    initialRoute: authC.skipIntro.isTrue
                        ? authC.isAuth.isTrue
                              ? Routes.HOME
                              : Routes.LOGIN
                        : Routes.INTRODUCTION,
                    getPages: AppPages.routes,
                  ),
                );
              }
              return FutureBuilder(
                future: authC.firstinitializeApp(),
                builder: (context, snapshot) => Splashscreen(),
              );
            },
          );
        }

        return Loadingpage();
      },
    ),
  );
}
