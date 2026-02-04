import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> chatStream(String email) { //function stream 
  

    return firestore.collection("users").doc(email).snapshots(); //ambil dari collection users dengan email yang login
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> UserStream(email) { //stream untuk user
    return firestore.collection("users").doc(email).snapshots(); //ambil dari collection users dengan email  teman kita

  }
}
