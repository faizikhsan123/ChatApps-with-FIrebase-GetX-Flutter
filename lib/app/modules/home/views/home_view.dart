import 'package:chat_apps/app/controllers/auth_c_controller.dart';
import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthCController>(); //import auth controller
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 6,
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQuery.padding.top),
              padding: const EdgeInsets.only(
                left: 20,
                right: 30,
                top: 20,
                bottom: 20,
              ),
              color: Colors.amberAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chats",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Material(
                    color: Colors.red,
                    shape: CircleBorder(),
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        Get.toNamed(Routes.PROFILE);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
        Expanded(
          
  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    
    //stream builder ngambil data realtimne wajib dikasi tipe
    stream: controller.chatStream(authC.user!.value.email!), 
    //jalankan stream dan ambil email user yang sedang login
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        //jika koenksi terhubung

        var allChats = (snapshot.data!.data() as Map<String, dynamic>)["chats"] as List;
        //ambil isi dari snapshot trs ambil data dari firebase kaarena data dari firebase masi object
        //diubah ke mapping trs ambil key chats dan diubah ke bentuk list
        //kenappa akrena memastikan var allchats adalah list dan bisa dapat length dkk

        return ListView.builder(
          itemCount: allChats.length,
          itemBuilder: (context, index) {
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              //stream builder kedua untuk user
              stream: controller.UserStream( allChats[index]["connection"]),
              //stream nya bngambil email  darri connection (email teman kita)

              builder: (context, snapshot2) {
                if (snapshot2.connectionState == ConnectionState.active) {

                  var allUser = snapshot2.data!.data() as Map<String, dynamic>;
                  //AMBIL DATA USER DARI SNAPSHOT2 (BUKAN SNAPSHOT)

                  return ListTile(
                    onTap: () {
                      Get.toNamed(
                        Routes.CHAT, 
                      );
                    },
                    leading: allUser["photoUrl"] == null ? CircleAvatar()
                     : CircleAvatar( //jika photoUrl null maka tampil circleavatar jika tidak tampil gambar
                      backgroundImage: NetworkImage(
                        allUser["photoUrl"],
                      ),
                    ),
                    title: Text(
                      allUser["name"] ?? "No Name", //ambil dari stream kedua
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      allUser["status"] ?? "", //ambil dari stream kedua
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: allChats[index]["total_unread"] == 0 ? null : Chip( //jika total_unread 0 maka null
                      label: Text(
                        allChats[index]["total_unread"].toString(), //ambil dari stream pertama
                      ),
                    ),
                    
                  );
                  
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        );
      }

      return Center(
        child: CircularProgressIndicator(),
      );
    },
  ),
),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.CARI);
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.search, size: 30, color: Colors.white),
      ),
    );
  }
}
