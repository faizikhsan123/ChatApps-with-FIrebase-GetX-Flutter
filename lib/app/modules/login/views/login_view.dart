import 'package:chat_apps/app/controllers/auth_c_controller.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

final authC = Get.find<AuthCController>();

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(193, 70, 116, 186),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: Get.height * 0.5,

                child: Lottie.asset('assets/lottie/login.json'),
              ),
            ),
            Container(
              width: Get.width * 0.8,
              height: Get.height * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  authC.login(); //jalankan functioin login yg ada di auth_c_controller
                  
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Get.height * 0.05,
                      child: Icon(
                        Icons.email,
                        size: 25,
                        color: const Color.fromARGB(255, 152, 46, 46),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Login With Google",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 17, 16, 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
