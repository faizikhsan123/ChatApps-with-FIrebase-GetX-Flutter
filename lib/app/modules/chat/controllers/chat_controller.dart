import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var IsShowEmoji = false.obs;

  late FocusNode focusNode;

  late TextEditingController chatC;

  void addEmojiToChat(Emoji emoji) {
    chatC.text = chatC.text + emoji.emoji;
  }

  void deleteEmoji() {
    chatC.text = chatC.text.substring(0, chatC.text.length - 2);
  }

  @override
  void onInit() {
    chatC = TextEditingController();

    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        IsShowEmoji.value = false;
      }
    });

    super.onInit();
  }

  @override
  void dispose() {
    focusNode.dispose();
    chatC.dispose();
    super.dispose();
  }

 void newChat(String email, String chatId, String friendEmail, String chat) async {
  CollectionReference chats = firestore.collection("chats");

  String date = DateTime.now().toIso8601String();

  //ambil document berdasarkan chat id lalu di chat id itu bikin sub collection chats dan tambahkan data
  await chats.doc(chatId).collection("chats").add({
    "pengirim": email, //email user yg login
    "penerima": friendEmail, // dari parameter
    "pesan": chat,//dari textfield
    "time": date,
    "isRead": false,
  });

  //update lastTime
  await chats.doc(chatId).update({
    "lastTime": date,
  });
}

}
