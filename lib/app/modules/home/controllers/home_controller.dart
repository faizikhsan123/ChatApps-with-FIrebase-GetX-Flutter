import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String email) {
    return firestore
        .collection("users")
        .doc(email)
        .collection("chats")
        .orderBy("lastTime", descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> UserStream(String email) {
    return firestore.collection("users").doc(email).snapshots();
  }

  void goTochatRoom(String chat_id, String email,String friendEmail) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");
    final updateStatusChat =
        await chats //ambil dari collection chats ambil sub collection chatsnya
            .doc(chat_id)
            .collection("chats")
            .where("isRead", isEqualTo: false) //yang isreaad false
            .where(
              "penerima",
              isEqualTo: email,
            ) //yang penerima sama dengan user yg login
            .get(); //ambil data

    updateStatusChat.docs.forEach((element) async {
      ///ini dia ngambil data satu persatu
      var updateStatusChat_id = element.id;

      ///ambil idnya si data satu persatu
      await chats
          .doc(chat_id)
          .collection("chats")
          .doc(updateStatusChat_id)
          .update({"isRead": true}); //update isreadnya jadi true
    });

    await users.doc(email).collection("chats").doc(chat_id).update({
      //ini yang di user update total unreadnya
      "total_unread": 0,
    });

    Get.toNamed(Routes.CHAT,parameters: { //jika function uda berjalan pindah halaman dan kirim parameter
      "chatId" : chat_id,
      "FriendEmail" : friendEmail
    } );

  }
}
