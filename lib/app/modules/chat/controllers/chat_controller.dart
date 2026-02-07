import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var IsShowEmoji = false.obs;

  late FocusNode focusNode;

  late TextEditingController chatC;

  int total_unread =0; //var total_unreead = 0;

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
  CollectionReference users = firestore.collection("users"); //tambaahkan collection users

  String date = DateTime.now().toIso8601String();

  //ambil document berdasarkan chat id lalu di chat id itu bikin sub collection chats dan tambahkan data
  final newChat = await chats.doc(chatId).collection("chats").add({
    "pengirim": email, //email user yg login
    "penerima": friendEmail, // dari parameter
    "pesan": chat,//dari textfield
    "time": date,
    "isRead": false,
  });

  await users.doc(email).collection("chats").doc(chatId).update( //masuk ke collection users di subcollection chats milik user yg login 
    { //trs update field tertentu
      "lastTime": date,
    }
  ); 

  final cekChatFriends = await users.doc(friendEmail).collection("chats").doc(chatId).get(); //ini untuk cek chat milik teman kita

  if (cekChatFriends.exists) { //jika chat milik teman kita sudah ada maka update lastTime
    int currentUnread = cekChatFriends.data()?["total_unread"] ?? 0;

    await users.doc(friendEmail).collection("chats").doc(chatId).update({
      "lastTime": date,
      "total_unread": currentUnread + 1,
    });
  } else { //jika chat milik teman kita belum ada maka tambahkan data
    await users.doc(friendEmail).collection("chats").doc(chatId).set({
      "connection": email,
      "lastTime": date,
      "total_unread": 1,
    });
  }

  //update lastTime
  await chats.doc(chatId).update({
    "lastTime": date,
  });
}


}
