import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var IsShowEmoji = false.obs;

  late FocusNode focusNode;

  late TextEditingController chatC;

  int total_unread = 0;

  //stream chats
  Stream<QuerySnapshot<Map<String, dynamic>>> chatStrem(String chatId)  {
    CollectionReference chats = firestore.collection("chats");

   return chats.doc(chatId).collection("chats").orderBy("time").snapshots(); //ambil data terbaru dari sub collectioin chats 

  }

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

  void newChat(
    String email,
    String chatId,
    String friendEmail,
    String chat,
  ) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    String date = DateTime.now().toIso8601String();

    final newChat = await chats.doc(chatId).collection("chats").add({
      "pengirim": email,
      "penerima": friendEmail,
      "pesan": chat,
      "time": date,
      "isRead": false,
    });

    await users.doc(email).collection("chats").doc(chatId).update({
      "lastTime": date,
    });

    final cekChatFriends = await users
        .doc(friendEmail)
        .collection("chats")
        .doc(chatId)
        .get();

    if (cekChatFriends.exists) {
      int currentUnread = cekChatFriends.data()?["total_unread"] ?? 0;

      await users.doc(friendEmail).collection("chats").doc(chatId).update({
        "lastTime": date,
        "total_unread": currentUnread + 1,
      });
    } else {
      await users.doc(friendEmail).collection("chats").doc(chatId).set({
        "connection": email,
        "lastTime": date,
        "total_unread": 1,
      });
    }

    await chats.doc(chatId).update({"lastTime": date});
  }

}
