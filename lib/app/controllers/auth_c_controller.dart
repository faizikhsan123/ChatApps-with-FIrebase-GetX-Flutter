import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCController extends GetxController {
  var skipIntro = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _currentUser;

  UserCredential? userCredential;

  Future<void> firstinitializeApp() async { //function pertama kali dijalankan
    await autoLogin().then((value) { //jalankan gunction auto login 
      if (value) { // bernilai true
        isAuth.value = true; //ganti nilai var isAuth menjadi true
      }
    },
    );
    await skipIntroo().then((value) { //jalankan function skip introo
      if (value) { // bernilai true
        skipIntro.value = true; //ganti nilai var skipIntro menjadi true
      }
    },

    );
  }

  Future<bool> autoLogin() async {  //function auto login bertipe bool jika perna login maka  bernilai true
  
    try {
      final isSignedIn = await _googleSignIn.isSignedIn(); //jika dia sudah pernah login maka bernilai true
      if (isSignedIn) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  Future<bool> skipIntroo() async { //functuion skip introo bertipe bool jika perna login maka  bernilai true
    try {
      final box = GetStorage(); //membuat box
      if (box.read('skip') != null || box.read('skip') == true) { //membaca key skip dan jika bernilai true kembalikan true
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
      
    }
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();

      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isLogin = await _googleSignIn.isSignedIn();

      if (isLogin) {
        print("sudah berhasil login");
        print(_currentUser);

        final gooleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: gooleAuth.idToken,
          accessToken: gooleAuth.accessToken,
        );

        await FirebaseAuth.instance .signInWithCredential(credential).then((value) => userCredential = value);

        print(userCredential);

        //jika sudah login maka buat box dengan nama skip dan bernilai true
        final box = GetStorage();
        if (box.read('skip') != null || box.read('skip') == true) { //membaca key skip dan jika bernilai true maka haus terlebih dahulu key skip
          box.remove('skip');          
        }
        box.write('skip', true); //jika sda dihapus maka buat baru  key skip bernilai true

        isAuth.value = true; //ganti nilai var isAuth menjadi true
        Get.offAllNamed(Routes.HOME); //pindah ke halaman home

      
      } else {
        print("gagal login");
      }
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
