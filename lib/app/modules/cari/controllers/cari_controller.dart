import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CariController extends GetxController {
  late TextEditingController searC;

  var queryresult = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchUser(String data) async {
    if (data.length == 0) {
      queryresult.value = [];
      tempSearch.value = [];
    } else {
      if (data.length != 0) {
        if (queryresult.length == 0 && data.length == 1) {
          CollectionReference users = await firestore.collection(
            "users", //ganti ke collectio nusers
          );
          final keyNameResult = await users
              .where('KeyName', isEqualTo: data.substring(0, 1).toUpperCase())
              .get();

          print(
            "TOtal data pada satu huruf ini : ${keyNameResult.docs.length}",
          );

          if (keyNameResult.docs.length > 0) {
            for (int i = 0; i < keyNameResult.docs.length; i++) {
              queryresult.add(
                keyNameResult.docs[i].data() as Map<String, dynamic>,
              );
            }
            print("query result ${queryresult}");
          }
        }

        if (queryresult.isNotEmpty) {
          tempSearch.value = [];

          queryresult.forEach((element) {
            if (element["name"]
                .toString() //→ ambil nama dari Firestore dan kemudian diubah menjadi string
                .toLowerCase()
                . //jika namanya huruf besar maka diubah menjadi huruf kecil
                startsWith(
                  data.toLowerCase(),
                ) ////jadi nama yg diinput awal akan diambil dan diubah menjadi huruf kecil
                ) {
              tempSearch.add(element); //tambahkan element ke tempSearch

              print( " temp : ${tempSearch}");
            }
          });
        }
      }
    }
    queryresult.refresh();
    tempSearch.refresh();
  }

  @override
  void onInit() {
    searC = TextEditingController();

    super.onInit();
  }

  @override
  void dispose() {
    searC.dispose();
    super.dispose();
  }
}
