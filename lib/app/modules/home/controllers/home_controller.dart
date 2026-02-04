import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  Stream<DocumentSnapshot<Map<String, dynamic>>> chatStream(String email) { //function stream 
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return firestore.collection("users").doc(email).snapshots(); //ambil dari collection users dengan email tertentu
  }
}
