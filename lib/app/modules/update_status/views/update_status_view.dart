import 'package:chat_apps/app/controllers/auth_c_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {

  final authC = Get.find<AuthCController>();
  @override
  Widget build(BuildContext context) {
    controller.statusC.text = authC.user!.value.status!; //nilai controller statusC diisi dengan status user
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Get.back(); 
        }, icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.amber,
        title: const Text('UpdateStatusView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: controller.statusC, //ngambil data dari controller
                cursorColor: Colors.black,
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
              Container(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    authC.changeStatus(controller.statusC.text); //jalankan function changeStatus
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
