import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
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
          //tombol di pojok kanan
          IconButton(onPressed: () {}, icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              //container untuk foto dan nama
              padding: const EdgeInsets.all(20),
              child: Container(
                width: Get.height * 0.2,
                height: Get.height * 0.2,
                child: AvatarGlow(
                  //avat glow untuk efek glow
                  startDelay: Duration(milliseconds: 1000), //durasi glow
                  glowColor: const Color.fromARGB(
                    255,
                    167,
                    162,
                    146,
                  ), //warna glow
                  glowShape: BoxShape.circle, //shape glow
                  child: Material(
                    elevation: 8,
                    shape:
                        CircleBorder(), //shape ngubah bentuk jadi bentuk lingkaran
                    child: CircleAvatar(
                      //circle avatar untuk bentuk lingkaran
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            Text(
              "Lorem Ipsum",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Lorem Ipsum @ gmail.com", style: TextStyle(fontSize: 15)),

            SizedBox(height: 30),

            Container(
              //container untuk tombol
              height: Get.height * 0.4,

              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.document_scanner, size: 28),
                    title: Text(
                      "Update Status ",
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(Icons.arrow_forward, size: 30),
                  ),
                  ListTile(
                    onTap: () {},
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
              //container untuk footer
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
