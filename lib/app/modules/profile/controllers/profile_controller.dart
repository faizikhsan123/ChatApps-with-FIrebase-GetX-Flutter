import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
 var isDark = Get.isDarkMode.obs;

void changeTheme() {
  if (isDark.value) {
    Get.changeTheme(ThemeData.light());
    isDark.value = false;
  } else {
    Get.changeTheme(ThemeData.dark());
    isDark.value = true;
  }
}

}
