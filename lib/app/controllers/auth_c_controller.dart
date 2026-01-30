import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCController extends GetxController {
  var skipIntro = false.obs;
  var isAuth = false.obs;

  // _ artinya private di dart

  final GoogleSignIn _googleSignIn = GoogleSignIn(); //membuat objek GoogleSignIn

  GoogleSignInAccount? _currentUser; //untuk menyimpan data akun Google user

  UserCredential? userCredential; //userCredential 

  Future<void> login() async {
    try {
      await _googleSignIn.signOut(); //memastikan agar user logout sebelum login

      await _googleSignIn.signIn().then((value) => _currentUser = value,); //menangkap data akun Google ke _currentUser

      final isLogin = await _googleSignIn.isSignedIn(); //untuk mengecek apakah user sudah login atau belum

      if (isLogin) { //islogin bernilai true jika user sudah login
        print("sudah berhasil login");
        print(_currentUser); //tampilkan data akun Google user di termnal

        final gooleAuth = await _currentUser!.authentication; //untuk mengambil data autentikasi (credential) dari currentUser

        final credential = GoogleAuthProvider.credential( //untuk membuat credential
          idToken: gooleAuth.idToken, //idtoken diambil dari data gooleAuth
          accessToken: gooleAuth.accessToken, //accesstoken diambil dari data gooleAuth
        );

       await FirebaseAuth.instance.signInWithCredential(credential).then((value) => userCredential = value,); //menangap data credential ke userCredential

       print(userCredential); //tampilkan data credential di terminal

      }
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    await _googleSignIn.signOut(); //untuk logout
    Get.offAllNamed(Routes.LOGIN);
  }
}
