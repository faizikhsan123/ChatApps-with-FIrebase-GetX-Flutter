import 'package:chat_apps/app/controllers/auth_c_controller.dart';
import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthCController>();

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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( //Digunakan untuk mengambil banyak dokumen hasil query.
              //stream ke subcollection chats milik user
              stream: controller.chatStream(authC.user!.value.email!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var listDocs = snapshot.data!.docs;
                  

                  if (listDocs.isEmpty) {
                    return Center(child: Text("Belum ada chat"));
                  }

                  return ListView.builder(
                    itemCount: listDocs.length,
                    itemBuilder: (context, index) {
                      var chatData = listDocs[index].data();

                      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller.UserStream(chatData["connection"]),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==ConnectionState.active) {
                            var allUser =snapshot2.data!.data() as Map<String, dynamic>;

                            return ListTile(
                              onTap: () {
                                //kirim chatId ke halaman chat
                                 Get.toNamed(
                                  Routes.CHAT,
                                  parameters: {   
                                    "chatId" : listDocs[index].id,
                                    "FriendEmail" : chatData["connection"],
                                  }
                                );
                              },
                              leading: allUser["photoUrl"] == null
                                  ? CircleAvatar()
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        allUser["photoUrl"],
                                      ),
                                    ),
                              title: Text(
                                allUser["name"] ?? "No Name",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                allUser["status"] ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: chatData["total_unread"] == 0
                                  ? null
                                  : Chip(
                                      label: Text(
                                        chatData["total_unread"].toString(),
                                      ),
                                    ),
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      );
                    },
                  );
                }

                return Center(child: CircularProgressIndicator());
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
