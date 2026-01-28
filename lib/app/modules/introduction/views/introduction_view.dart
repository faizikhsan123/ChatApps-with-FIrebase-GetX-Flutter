import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  @override
  Widget build(BuildContext context) {
    final introKey =
        GlobalKey<
          IntroductionScreenState
        >(); //membuat key agar kita tahu halaman nya seperti index
    return Scaffold(
      body: Center(
        child: IntroductionScreen(
          //widget introduction screen
          pages: [
            PageViewModel(
              // halaman pertama
              title: "Welcome to Chat Apps",
              body: "Ngobrol lebih cepat, aman, dan nyaman dengan siapa saja.",
              image: Container(
                height: Get.height * 0.6,
                child: Center(
                  child: Lottie.asset("assets/lottie/dua.json", height: 200),
                ),
              ),
            ),
            PageViewModel(
              // halaman kedua
              title: "Realtime Messaging",
              body: "Kirim dan terima pesan secara realtime tanpa delay.",
              image: Container(
                height: Get.height * 0.6,
                child: Center(
                  child: Lottie.asset("assets/lottie/tiga.json", height: 200),
                ),
              ),
            ),
            PageViewModel(
              // halaman ketiga
              title: "Secure & Private",
              body:
                  "Privasi kamu adalah prioritas kami dengan sistem keamanan terbaik.",
              image: Container(
                height: Get.height * 0.6,
                child: Center(
                  child: Lottie.asset("assets/lottie/empat.json", height: 200),
                ),
              ),
            ),
            PageViewModel(
              // halaman keempat
              title: "Get Started",
              body: "Masuk dan mulai percakapan dengan temanmu sekarang juga.",
              image: Container(
                height: Get.height * 0.6,
                child: Center(
                  child: Lottie.asset("assets/lottie/lima.json", height: 200),
                ),
              ),
            ),
          ],
          showSkipButton: true, //akliin tombol skip
          skip: Text("Skip"), //widget untuk skip
          next: Text("Next"), //widget untuk next
          done: Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.w700),
          ), //widget untuk done
          onDone: () {
            // On Done button pressed
            Get.toNamed(Routes.LOGIN);
          },
          onSkip: () {
            // On Skip button
            introKey.currentState?.animateScroll(
              4,
            ); //langsung ke halaman ketiga
          },

          dotsDecorator: DotsDecorator(
            //untuk edit yg titik titik (dots)
            size: Size.square(10.0),
            activeSize: Size(20.0, 10.0),
            activeColor: Theme.of(context).colorScheme.secondary,
            color: Colors.black26,
            spacing: EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
