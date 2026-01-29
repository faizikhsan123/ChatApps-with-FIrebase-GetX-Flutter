

import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCController extends GetxController {
  var skipIntro = false.obs;
  var isAuth = false.obs;

  // _ artinya private di dart


  final GoogleSignIn _googleSignIn = GoogleSignIn();//membuat objek GoogleSignIn

  GoogleSignInAccount? _currentUser; //untuk menyimpan data akun Google user

  Future<void> login() async {    //fungsi untuk login gogle

    try {
      // Membuka popup login Google.
      // Jika user berhasil login, data akun Google (email, nama, foto, dll)
      // akan disimpan ke dalam variabel _currentUser.
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      await _googleSignIn.isSignedIn().then((value) { //untuk mengecek apakah user sudah login atau belum
        if (value) { //jika sudah login (value = true)
        print("Sudah berhasil login");
        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
        print(_currentUser); //tampilkan data var  _currentUser di debug console
        
        } else {
          print("Belum login");
        }
      });
    } catch (error) {
      print(error);
    }
  }

  void logout() async { //fungsi untuk logout
  await _googleSignIn.signOut(); //untuk logout
    Get.offAllNamed(Routes.LOGIN); 
  }
}
