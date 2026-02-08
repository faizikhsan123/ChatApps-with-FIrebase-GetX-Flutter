import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var IsShowEmoji = false.obs;

  late FocusNode focusNode;

  late TextEditingController chatC;
  late ScrollController scrollController; //untuk autoscroll pada listview

  int total_unread = 0;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStrem(String chatId) {
    CollectionReference chats = firestore.collection("chats");

    return chats.doc(chatId).collection("chats").orderBy("time").snapshots();
  }
  Stream<DocumentSnapshot<Object?>> FriendStream(String friendEmail){ //stream data teman
    CollectionReference users = firestore.collection("users");

   return users.doc(friendEmail).snapshots();
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
    scrollController = ScrollController(); //tambhakn ini
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
    scrollController.dispose(); //tambhakn ini
    chatC.dispose();
    super.dispose();
  }

 void newChat(String email,String chatId,String friendEmail,String chat,) async {
  String message = chat.trim(); //trim untuk menghilangkan spasi di awal dan akhir string : "   hello   " => "hello"
  if (message.isEmpty) return; //jika message kosong maka  tidak dijalankan

  CollectionReference chats = firestore.collection("chats");
  CollectionReference users = firestore.collection("users");

  String date = DateTime.now().toIso8601String();

 await chats.doc(chatId).collection("chats").add({
    "pengirim": email,
    "penerima": friendEmail,
    "pesan": message,
    "time": date,
    "isRead": false,
  });

  chatC.clear(); //clear textfield

    scrollController.animateTo(
      scrollController.position.maxScrollExtent, //kebawah
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );


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

  
