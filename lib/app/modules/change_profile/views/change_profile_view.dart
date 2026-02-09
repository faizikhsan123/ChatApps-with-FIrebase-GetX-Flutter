import 'dart:io';

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
    controller.emailC.text = authC.user.value.email!;
    controller.nameC.text = authC.user.value.name!;
    controller.statusC.text = authC.user.value.status!;

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
                controller.nameC.text,
                controller.statusC.text,
              );
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
                      child: Obx(
                        () => CircleAvatar(
                          radius: 60,
                          backgroundImage: authC.user.value.photoUrl == null //jika photoUrl null
                              ? NetworkImage(
                                  "https://i.ibb.co/2kR8Y7b/default-avatar.png",
                                )
                              : NetworkImage(authC.user.value.photoUrl!), //jika photoUrl tidak null
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
                  GetBuilder<ChangeProfileController>(
                    //get buildedr ini memperbarui tampilan seperti obx namun karena XFile tidak ada rx (tidak bisa di obs) maka pakai GetBuilder. dan mharus dikasi tipe controller
                    builder: (controller) => controller.pickedImage != null
                        ? Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: Image.file(
                                          //image file menampilkan gambar dari file memalui path gambar yg dipilih
                                          File(controller.pickedImage!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            controller
                                                .deleteImage(); //untuk menghapus gambar
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        color: Colors.black45,
                                        height: 30,
                                        child: TextButton(
                                          onPressed: () {
                                            controller.uploadImageToCloudinary(
                                              authC.user.value.email!,
                                            ); //fungsi upload ke cloudinary
                                          },

                                          child: FittedBox(
                                            child: Text(
                                              "upload Image",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Text("No Image Selected"),
                  ),

                  TextButton(
                    onPressed: () {
                      controller.selectImage(); //jalankan function select image
                    },
                    child: Text("Pilih FIle"),
                  ),
                ],
              ),

              Container(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    authC.changeProfile(
                      controller.nameC.text,
                      controller.statusC.text,
                    );
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
