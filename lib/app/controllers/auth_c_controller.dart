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

  var user = TestUser().obs;

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
        await _googleSignIn.signInSilently().then(
          (value) => _currentUser = value,
        );

        final gooleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: gooleAuth.idToken,
          accessToken: gooleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        CollectionReference users = firestore.collection("users");

        await users.doc(_currentUser!.email).update({
          'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!
              .toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        final userTerkini = await users.doc(_currentUser!.email).get();

        final dataUserTerkini = userTerkini.data() as Map<String, dynamic>;

        user(TestUser.fromJson(dataUserTerkini));
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

        CollectionReference users = firestore.collection("users");

        final chekuser = await users.doc(_currentUser!.email).get();

        if (chekuser.exists) {
          await users.doc(_currentUser!.email).update({
            'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!
                .toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
        } else {
          await users.doc(_currentUser!.email).set({
            'uid': userCredential!.user!.uid,
            'name': _currentUser!.displayName,
            'email': _currentUser!.email,
            'photoUrl': _currentUser!.photoUrl,
            'status': "",
            'createdAt': userCredential!.user!.metadata!.creationTime!
                .toIso8601String(),
            'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!
                .toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
            'KeyName': _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            'chats': [],
          });
        }

        final userTerkini = await users.doc(_currentUser!.email).get();

        final dataUserTerkini = userTerkini.data() as Map<String, dynamic>;

        user(TestUser.fromJson(dataUserTerkini));

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
      'name': name,
      'KeyName': name.substring(0, 1).toUpperCase(),
      'status': status,
      'updatedAt': date,
      'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!
          .toIso8601String(),
    });

    user.update((val) {
      val!.name = name;
      val!.keyName = name.substring(0, 1).toUpperCase();
      val!.status = status;
      val!.updatedAt = date;
      val!.lastSignIn = userCredential!.user!.metadata!.lastSignInTime!
          .toIso8601String();
    });
    user.refresh();
    Get.defaultDialog(
      title: "Success",
      middleText: "Update profile success",
      onConfirm: () {
        Get.back();
        Get.back();
      },
    );
  }

  void changeStatus(String status) {
    CollectionReference users = firestore.collection("users");

    String date = DateTime.now().toIso8601String();

    users.doc(_currentUser!.email).update({
      'status': status,
      'updatedAt': date,
      'lastSignIn': userCredential!.user!.metadata!.lastSignInTime!
          .toIso8601String(),
    });

    user.update((val) {
      val!.status = status;
      val!.updatedAt = date;
      val!.lastSignIn = userCredential!.user!.metadata!.lastSignInTime!
          .toIso8601String();
    });

    user.refresh();

    Get.defaultDialog(
      title: "Success",
      middleText: "Update status success",
      onConfirm: () {
        Get.back();
        Get.back();
      },
    );
  }

  void addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    final date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final docUser = await users
        .doc(_currentUser!.email)
        .get(); //ambil data user

    final docChat = (docUser.data() as Map<String, dynamic>)["chats"] as List;
    //hanya mengambil data chat saja dan diubah menjadi list

    var chat_id; //variabel untuk menyimpan chat id

    if (docChat.isNotEmpty) {
      //kalo doc chat ada datanya
      for (var element in docChat) {
        if (element["connection"] == friendEmail) {
          //jika koneksi sama
          chat_id = element["chat_id"]; //ambil chat idnya
          break;
        }
      }

      if (chat_id != null) {
        flagNewConnection = false; //sudah pernah chat
      } else {
        flagNewConnection = true; //belum pernah chat dengan dia
      }
    } else {
      flagNewConnection = true; //belum pernah chat sama siapapun
    }

    if (flagNewConnection) {
      //cek dari collection chats cari yang connectionnya mereka berdua
      final cekKoneksiberdua = await chats
          .where(
            "connection",
            whereIn: [
              [_currentUser!.email, friendEmail],
              [friendEmail, _currentUser!.email], //tidak peduli urutan
            ],
          )
            .limit(1)
          .get();

      if (cekKoneksiberdua.docs.isNotEmpty) {
        //jika ditemukan isi dari cekKoneksiberdua (field connection)
        final chatDataId = cekKoneksiberdua.docs.first.id; //ambil idnya
        final chatData = cekKoneksiberdua.docs.first.data() as Map<String, dynamic>; //ambil datanya first itu seperti [0] jadi dia pasti unik / tidak ada duplikat


        await users.doc(_currentUser!.email).update({
          "chats": FieldValue.arrayUnion([
             //tambah data ke array, kalau belum ada yang sama persis

          // Sifat penting:

          // ✅ Tidak menimpa isi chats lama

          // ✅ Tidak bikin duplikat kalau isinya SAMA PERSIS

          // ❌ Kalau beda dikit → tetap masuk
            {
              "connection": friendEmail,
              "chat_id": chatDataId,
              "lastTime": chatData["lastTime"],
            },
          ]),
        });

        user.update((val) {
          val!.chats ??= []; //jika null, buat array
          val.chats!.add(
            ChatsUser(
              connection: friendEmail,
              chatId: chatDataId,
              lastTime: chatData["lastTime"],
            ),
          );
        });

        chat_id = chatDataId;
        user.refresh();

        //PENTING: karena chat lama sudah ada → JANGAN bikin docs baru
        Get.toNamed(Routes.CHAT, arguments: chat_id);
        return; // ⬅️ ⬅️ ⬅️ INI PENYELAMAT HIDUP
      }

      //mereka belum pernah chat jadi buat baru
      final newChatDocs = await chats.add({
        "connection": [_currentUser!.email, friendEmail],
        "total_chat": 0,
        "total_read": 0,
        "total_unread": 0,
        "chat": [],
        "lastTime": date,
      });

      await users.doc(_currentUser!.email).update({
        "chats": FieldValue.arrayUnion([
          //tambah data ke array, kalau belum ada yang sama persis

          // Sifat penting:

          // ✅ Tidak menimpa isi chats lama

          // ✅ Tidak bikin duplikat kalau isinya SAMA PERSIS

          // ❌ Kalau beda dikit → tetap masuk
          {
            "connection": friendEmail,
            "chat_id": newChatDocs.id,
            "lastTime": date,
          },
        ]),
      });

      user.update((val) {
        val!.chats ??= []; //kalo ga ada chats, buat array
        val.chats!.add(
          ChatsUser(
            connection: friendEmail,
            chatId: newChatDocs.id,
            lastTime: date,
          ),
        );
      });

      chat_id = newChatDocs.id;
      user.refresh();
    }

    if (chat_id != null) {
      print(chat_id);
      Get.toNamed(Routes.CHAT, arguments: chat_id);
    }
  }
}
