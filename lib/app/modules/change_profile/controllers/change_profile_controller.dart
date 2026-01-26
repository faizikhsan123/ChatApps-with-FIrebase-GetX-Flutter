import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;

  @override
  void onInit() { //kketiak controller pertama kali jalan sudah memberi nilai default
    emailC = TextEditingController(text: "lorem ipsum @ gmail.com");
    nameC = TextEditingController(text: "Lorem Ipsum");
    statusC = TextEditingController(text: "status abg dek");
    super.onInit();
  }

  @override
  void onClose() { //agar memrori tidak leak
    emailC.dispose();
    nameC.dispose();
    statusC.dispose();
    // TODO: implement onClose
    super.onClose();
  }

}
