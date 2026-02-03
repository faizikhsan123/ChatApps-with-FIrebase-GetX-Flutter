import 'package:chat_apps/app/controllers/auth_c_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/cari_controller.dart';

class CariView extends GetView<CariController> {
  final authC = Get.find<AuthCController>();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 64, 61, 61),
          title: Text('Search'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back),
          ),
          flexibleSpace: Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) =>
                    controller.searchUser(value, authC.user!.value.email!),
                controller: controller.searC,
                cursorColor: Colors.amber,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Cari orang',
                  suffixIcon: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: Icon(Icons.search, color: Colors.amber),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(140),
      ),
      body: Obx(
        () => controller.tempSearch.isEmpty
            ? Center(
                child: SizedBox(
                  width: Get.width * 0.8,
                  height: Get.height * 0.8,
                  child: Lottie.asset('assets/lottie/kosong.json'),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.tempSearch.length,
                itemBuilder: (context, index) {
                  final user = controller.tempSearch[index];

                  return ListTile(
                    leading: CircleAvatar(),
                    title: Text(
                      user['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      user['email'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: InkWell(
                      onTap: () {
                        authC.addNewConnection(user['email']);
                      },
                      child: const Chip(label: Text("message")),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
