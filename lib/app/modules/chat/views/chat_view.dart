import 'package:chat_apps/app/controllers/auth_c_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final authC = Get.find<AuthCController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leadingWidth: 100,
        leading: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            return Get.back();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 5),
              Icon(Icons.arrow_back_ios),
              SizedBox(width: 5),
              CircleAvatar(
                child: StreamBuilder<DocumentSnapshot<Object?>>(
                  stream: controller.FriendStream(
                    Get.parameters["FriendEmail"]!,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var dataFriend =
                          snapshot.data!.data() as Map<String, dynamic>;
                      if (dataFriend["photoUrl"] == null) {
                        return CircleAvatar(
                          child: Icon(Icons.person, size: 35),
                          radius: 25,
                          backgroundColor: const Color.fromARGB(
                            96,
                            243,
                            243,
                            243,
                          ),
                        );
                      }
                      return CircleAvatar(
                        backgroundImage: NetworkImage(dataFriend["photoUrl"]),
                        radius: 25,
                        backgroundColor: const Color.fromARGB(
                          96,
                          243,
                          243,
                          243,
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                radius: 25,
                backgroundColor: Colors.black38,
              ),
            ],
          ),
        ),
        title: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: controller.FriendStream(Get.parameters["FriendEmail"]!),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.active) {
              var dataFriend =
                  asyncSnapshot.data!.data() as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataFriend["name"]! ?? "Loading...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    dataFriend["status"]! ?? "Loading...",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: Get.width,
              height: Get.height,
              color: const Color.fromARGB(255, 101, 93, 72),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.chatStrem(Get.parameters["chatId"]!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var Alldata = snapshot.data!.docs;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (controller.scrollController.hasClients) {
                        controller.scrollController.animateTo(
                          controller.scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });

                    return ListView.builder(
                      controller: controller.scrollController,
                      itemCount: Alldata.length,
                
                      itemBuilder: (context, index) {
                        if (index == 0) { //jika data pertamaa
                          return Column(
                            children: [
                              Text(Alldata[index]["GroupTime"]),
                              ItemsChat(
                                isSender:
                                    Alldata[index]["pengirim"] ==
                                        authC.user.value.email
                                    ? true
                                    : false,
                                pesan: "${Alldata[index]["pesan"]}",
                                time: Alldata[index]["time"],
                              ),
                            ],
                          );
                        }else { //jika index selain pertama group timenya sama dengan index sebelumnya maka 
                          if (Alldata[index]["GroupTime"] == Alldata[index -1]["GroupTime"]) { //tanggal pesan sekarang == tanggal pesan sebelumnya
                            return ItemsChat(
                              isSender:
                                  Alldata[index]["pengirim"] ==
                                      authC.user.value.email
                                  ? true
                                  : false,
                              pesan: "${Alldata[index]["pesan"]}",
                              time: Alldata[index]["time"],
                            );
                            
                          }else {
                            return Column(
                              children: [
                                Text(Alldata[index]["GroupTime"]),
                                ItemsChat(
                                  isSender:
                                      Alldata[index]["pengirim"] ==
                                          authC.user.value.email
                                      ? true
                                      : false,
                                  pesan: "${Alldata[index]["pesan"]}",
                                  time: Alldata[index]["time"],
                                ),
                              ],
                            );
                          }
                        }
                      } 
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: Get.width,
            height: 100,
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: controller.chatC,
                      focusNode: controller.focusNode,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            controller.focusNode.unfocus();
                            controller.IsShowEmoji.toggle();
                          },
                          icon: Icon(Icons.emoji_emotions_outlined),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 191, 191, 191),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 28, 27, 27),
                            width: 2,
                          ),
                        ),
                        labelText: 'Pesan',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Colors.blue,
                  child: InkWell(
                    child: IconButton(
                      onPressed: () {
                        controller.newChat(
                          authC.user.value.email!,
                          Get.parameters["chatId"]!,
                          Get.parameters["FriendEmail"]!,
                          controller.chatC.text,
                        );
                      },
                      icon: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Obx(
            () => controller.IsShowEmoji.isTrue
                ? Container(
                    height: 300,
                    child: EmojiPicker(
                      onEmojiSelected: (Category? category, Emoji emoji) {
                        controller.addEmojiToChat(emoji);
                      },

                      onBackspacePressed: () {
                        controller.deleteEmoji();
                      },

                      config: Config(
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          emojiSizeMax: 28,
                          columns: 5,
                        ),
                        viewOrderConfig: const ViewOrderConfig(
                          top: EmojiPickerItem.categoryBar,
                          middle: EmojiPickerItem.emojiView,
                          bottom: EmojiPickerItem.searchBar,
                        ),
                        skinToneConfig: const SkinToneConfig(),
                        categoryViewConfig: const CategoryViewConfig(),
                        bottomActionBarConfig: const BottomActionBarConfig(),
                        searchViewConfig: const SearchViewConfig(),
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

class ItemsChat extends StatelessWidget {
  const ItemsChat({
    super.key,
    required this.isSender,
    required this.pesan,
    required this.time,
  });

  final bool isSender;
  final String pesan;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment: isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 171, 163, 138),
              borderRadius: isSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(isSender ? 10 : 0),
                      bottomRight: Radius.circular(isSender ? 0 : 10),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(isSender ? 0 : 10),
                      topRight: Radius.circular(isSender ? 10 : 0),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
            ),
            child: Text("$pesan"),
          ),
          Text(
            DateFormat.jm().format(DateTime.parse(time)),
          ), //ambil waktunya pake packagge intl time nya yg awalnya dari string harus diubah ke bentuk DateTime lagi karena ketentuan DateFormat jm itu jam dan menit
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
