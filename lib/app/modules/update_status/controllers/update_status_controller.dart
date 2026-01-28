import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UpdateStatusController extends GetxController {
 late TextEditingController statusC;
  @override
  void onInit() {
    statusC = TextEditingController();
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    statusC.dispose();
    // TODO: implement onClose
    super.onClose();
  }
}
