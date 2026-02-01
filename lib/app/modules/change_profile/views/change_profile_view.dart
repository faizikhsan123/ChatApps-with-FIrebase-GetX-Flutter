import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_apps/app/controllers/auth_c_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final authC = Get.find<AuthCController>();
  @override
  Widget build(BuildContext context) {
    //jadi controller ini isinya data user yang sedang login
    controller.emailC.text = authC.user!.value.email!;
    controller.nameC.text = authC.user!.value.name!;
    controller.statusC.text = authC.user!.value.status!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.amber,
        title: const Text('changeProfile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              authC.changeProfile(
                  controller.nameC.text, controller.statusC.text);
            },
            icon: Icon(Icons.save_alt_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
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
                    child: Material(
                      elevation: 8,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                cursorColor: Colors.black,
                controller: controller.emailC,
                readOnly: true, //tidak bisa di edit
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                  ),
                  labelText: 'Email',
                  
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.nameC,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                  ),
                  labelText: 'name',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.statusC,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                  ),
                  labelText: 'status',
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("No Image"),
                  TextButton(onPressed: () {}, child: Text("Pilih FIle")),
                ],
              ),
              Container(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    authC.changeProfile(
                      controller.nameC.text,
                      controller.statusC.text,
                    ); //jalankan function change profile dan kirimkan data email dan status
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
