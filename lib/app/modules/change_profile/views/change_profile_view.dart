import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  const ChangeProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Get.back(); //akan mengembalikan ke halaman sebelumnya
        }, icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.amber,
        title: const Text('changeProfile'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.save_alt_rounded,color: Colors.white,))
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
                  glowColor: const Color.fromARGB(
                    255,
                    167,
                    162,
                    146,
                  ), 
                  glowShape: BoxShape.circle, 
                  child: Material(
                    elevation: 8,
                    shape:
                        CircleBorder(),
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


              TextField(  //email
                cursorColor: Colors.black,
                controller: controller.emailC, 
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
              TextField( //name
                controller: controller.nameC, 
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
                  labelText: 'name',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller:
                    controller.statusC, 
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
                  onPressed: () {},
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
