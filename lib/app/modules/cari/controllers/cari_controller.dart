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
        //kita koosongkan dulu data (apa yg diketik user)
        queryresult.value = [];
        tempSearch.value = [];
      } else {
        if (data.length != 0) {
          var kapital = data.substring(0, 1).toUpperCase() + data.substring(1,); //mengambil huruf pertama dari ketikan user dan dijadikan kapital dan mengambil huruf selanjutnya

          print("Kapital : $kapital");

          if (queryresult.length == 0 && data.length == 1) {      //fungsi pada ketikan satu huruf
      
            CollectionReference clients = await firestore.collection("clients",); //ambbil dari collecion clients
            final keyNameResult = await clients
                .where('KeyName', isEqualTo: data.substring(0, 1).toUpperCase())
                .get(); //ambil data berdasarkan huruf pertama. isequalto artinya sama dengan

            print(
              "TOtal data pada satu huruf ini : ${keyNameResult.docs.length}",
            );

            if (keyNameResult.docs.length > 0) {
              for (int i = 0; i < keyNameResult.docs.length; i++) {
                queryresult.add(
                  keyNameResult.docs[i].data() as Map<String, dynamic>,
                ); //query awal ditambah  data dari collection clients
              }
              print("query result ${queryresult}");
            }
          }

          if (queryresult.length != 0) {
            tempSearch.value = [];
            queryresult.forEach((element) { //Ambil data di queryresult satu per satu
          
              if (element["name"].startsWith(kapital)) {//jika huruf pertama diambil dari data query result sama dengan hurpertama yg diketik user
                tempSearch.add(element);  //data tersebut ditambahkan ke tempSearch
              
                
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
      // TODO: implement onInit
      super.onInit();
    }

    @override
    void dispose() {
      // TODO: implement dispose
      searC.dispose();
      super.dispose();
    }
  }
