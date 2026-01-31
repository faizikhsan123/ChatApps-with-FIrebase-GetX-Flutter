import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  FirebaseFirestore firestore = FirebaseFirestore.instance; //inisialize firestore

  

  Future<void> firstinitializeApp() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });
    await skipIntroo().then((value) {
      if (value) {
        skipIntro.value = true;
      }
    });
  }

  Future<bool> autoLogin() async {
    try {
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> skipIntroo() async {
    try {
      final box = GetStorage();
      if (box.read('skip') != null || box.read('skip') == true) {
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

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print(userCredential);

        //simpan data login ke firestore database
      CollectionReference users = firestore.collection("users"); //var users diambil / membuat  collection users

      //menambahkan data ke firestore
      users.doc(_currentUser!.email)  //membuat id di firestoree nya dari email current user
      .set({ // set (set ini bagian data / field) diambil dari current user dan user credential
        'uid': userCredential!.user!.uid,
        'name': _currentUser!.displayName,
        'email': _currentUser!.email,
        'photoUrl': _currentUser!.photoUrl,
        'status': "",
        'createdAt': userCredential!.user!.metadata!.creationTime!.toIso8601String(), //karena waktu bukan string kita convert ke string dengan toIso8601String
        'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String()
      });



        final box = GetStorage();
        if (box.read('skip') != null || box.read('skip') == true) {
          box.remove('skip');
        }
        box.write('skip', true);

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
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
