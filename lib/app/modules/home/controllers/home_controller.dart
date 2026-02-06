import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //stream daftar chat milik user (subcollection)
  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String email) {  //Digunakan untuk mengambil banyak dokumen hasil qu
    return firestore
        .collection("users") //ambil dari collection users
        .doc(email) //doc user yg login
        .collection("chats") //subcollection chats
        .orderBy("lastTime", descending: true) //urutkan berdasarkan waktu terakhir
        .snapshots();
  }

  //stream data user lawan chat
  Stream<DocumentSnapshot<Map<String, dynamic>>> UserStream(String email) {
    return firestore
        .collection("users") //ambil dari collection users
        .doc(email) //ambil doc berdasarkan email
        .snapshots();
  }
}
