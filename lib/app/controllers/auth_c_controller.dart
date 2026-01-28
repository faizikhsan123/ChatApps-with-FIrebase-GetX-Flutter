
import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:get/get.dart';

class AuthCController extends GetxController {
  
  var skipIntro = false.obs; 
  var isAuth = false.obs; 


//function ini rekayasa hanya dibutuhkan karena kita blm punya function beneran (ini hanyynya memindahkan halaman)
//offallnamed menghapus halaman yg ada sebelumnya
  void login(){
    Get.offAllNamed(Routes.HOME);
  }

  void logout(){
    Get.offAllNamed(Routes.LOGIN);
  }
  

 
}
