
import 'package:chat_apps/app/data/models/test_user_model.dart';
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

  FirebaseFirestore firestore = FirebaseFirestore.instance;

 var user = TestUser().obs; //ganti modelsnya

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
        
        
        await _googleSignIn.signInSilently().then((value) => _currentUser = value,);

        final gooleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: gooleAuth.idToken,
          accessToken: gooleAuth.accessToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential).then((value) => userCredential = value);

        CollectionReference users = firestore.collection("users");

        users.doc(_currentUser!.email).update({
          'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!
              .toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        final userTerkini = await users.doc(_currentUser!.email).get();

        final dataUserTerkini = userTerkini.data() as Map<String, dynamic>;

       

        user (TestUser(  //ganti modelsnya
          uid: dataUserTerkini['uid'],
          name: dataUserTerkini['name'],
          email: dataUserTerkini['email'],
          status: dataUserTerkini['status'],
          createdAt: dataUserTerkini['createdAt'],
          updatedAt: dataUserTerkini['updatedAt'],
          photoUrl: dataUserTerkini['photoUrl'],
          lastSignIn: dataUserTerkini['lastSignIn'],
          keyName: dataUserTerkini['KeyName'], //tmabahkan keyname
        ));

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

        await FirebaseAuth.instance.signInWithCredential(credential).then((value) => userCredential = value);

        print(userCredential);

        CollectionReference users = firestore.collection("users");

        
        final chekuser = await users.doc(_currentUser!.email).get(); 

        if (chekuser.exists) {
          
          users.doc(_currentUser!.email).update({
            'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!.toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
        } else {
          
          users.doc(_currentUser!.email).set({
            'uid': userCredential!.user!.uid,
            'name': _currentUser!.displayName,
            'email': _currentUser!.email,
            'photoUrl': _currentUser!.photoUrl,
            'status': "",
            'createdAt': userCredential!.user!.metadata!.creationTime!.toIso8601String(),
            'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!.toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
            'KeyName': _currentUser!.displayName!.substring(0, 1).toUpperCase(), //untuk ambil keyname
          });
        }

        
        final userTerkini = await users.doc(_currentUser!.email).get();

        
        final dataUserTerkini = userTerkini.data() as Map<String, dynamic>;

        
        user (TestUser( //ganti modelsnya
          uid: dataUserTerkini['uid'],
          name: dataUserTerkini['name'],
          email: dataUserTerkini['email'],
          status: dataUserTerkini['status'],
          createdAt: dataUserTerkini['createdAt'],
          updatedAt: dataUserTerkini['updatedAt'],
          photoUrl: dataUserTerkini['photoUrl'],
          lastSignIn: dataUserTerkini['lastSignIn'],
          keyName: dataUserTerkini['KeyName'], //tambahkan keyname
        ));

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

  
  void changeProfile(String name, String status) {
    CollectionReference users = firestore.collection("users"); 

    String date = DateTime.now().toIso8601String(); 

    users.doc(_currentUser!.email).update({ 
      'name' : name,
      'KeyName' : name.substring(0, 1).toUpperCase(), //nama berubah Keyname juga berubah
      'status' : status,
      'updatedAt': date,
      'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!.toIso8601String(),
    });

    
   user.update((val) {
     val!.name = name;
     val!.keyName = name.substring(0, 1).toUpperCase(); //update keyname nya juga
     val!.status = status;
     val!.updatedAt = date;
     val!.lastSignIn = userCredential!.user!.metadata!.lastSignInTime!.toIso8601String();

   },);
    user.refresh(); 
    Get.defaultDialog(
      title: "Success",
      middleText: "Update profile success",
      onConfirm: () {
        Get.back();
        Get.back();
      } 
    );
  }

  void changeStatus (String status) {
    CollectionReference users = firestore.collection("users"); 

    String date = DateTime.now().toIso8601String(); 

    users.doc(_currentUser!.email).update({ 
      'status' : status,
      'updatedAt': date,
      'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!.toIso8601String(),
    });

    user.update((val) {
      val!.status = status;
      val!.updatedAt = date;
      val!.lastSignIn = userCredential!.user!.metadata!.lastSignInTime!.toIso8601String();
    },);

    user.refresh();

    Get.defaultDialog(
      title: "Success",
      middleText: "Update status success",
      onConfirm: () {
        Get.back();
        Get.back();
      }
    );
  }
}
