import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CariController extends GetxController {
 late TextEditingController searC;

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
