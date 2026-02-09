import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_apps/app/controllers/auth_c_controller.dart';
import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthCController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              authC.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: Get.height * 0.2,
                height: Get.height * 0.2,

                child: AvatarGlow(
                  startDelay: Duration(milliseconds: 1000),
                  glowColor: const Color.fromARGB(255, 167, 162, 146),
                  glowShape: BoxShape.circle,
                  child: Obx(
                    () => Container(
                      margin: EdgeInsets.all(15),
                      width: 200,
                      height: 200,
                      child:
                          authC.user?.value.photoUrl ==
                              null //jika image null tampilkan gambar default
                          ? Image.asset(
                              "assets/logo/profile.png",
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              //jika tidak null tampilkan gambar dari firebase
                              "${authC.user?.value.photoUrl}",
                              fit: BoxFit.cover,
                            ),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(100),

                        image: DecorationImage(
                          image: AssetImage("assets/logo/profile.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            Obx(
              () => Text(
                "${authC.user?.value.name}", //ngambil data dari model karena modelnya uda obx kita harus tambah .value
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "${authC.user?.value.email}",
              style: TextStyle(fontSize: 15),
            ), //kenapa email tidak di obx karena emailnya tidak bisa di update

            SizedBox(height: 30),

            Container(
              height: Get.height * 0.4,

              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.toNamed(Routes.UPDATE_STATUS);
                    },
                    leading: Icon(Icons.document_scanner, size: 28),
                    title: Text(
                      "Update Status ",
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(Icons.arrow_forward, size: 30),
                  ),
                  ListTile(
                    onTap: () {
                      Get.toNamed(Routes.CHANGE_PROFILE);
                    },
                    leading: Icon(Icons.person, size: 28),
                    title: Text(
                      "Update Profile ",
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(Icons.arrow_forward, size: 30),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.theater_comedy, size: 28),
                    title: Text("Change Theme", style: TextStyle(fontSize: 18)),
                    trailing: Text("Light", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("chaat App", style: TextStyle(fontSize: 18)),
                      Text("V 1.3.4", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
