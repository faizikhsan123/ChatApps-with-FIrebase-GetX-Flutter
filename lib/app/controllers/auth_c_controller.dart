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
        });

        final userTerkini = await users.doc(_currentUser!.email).get();

        final dataUserTerkini = userTerkini.data() as Map<String, dynamic>;

        user(
          TestUser(
            uid: dataUserTerkini["uid"],
            email: dataUserTerkini["email"],
            name: dataUserTerkini["name"],
            status: dataUserTerkini["status"],
            createdAt: dataUserTerkini["createdAt"],
            updatedAt: dataUserTerkini["updatedAt"],
            photoUrl: dataUserTerkini["photoUrl"],
            lastSignIn: dataUserTerkini["lastSignIn"],
            keyName: dataUserTerkini["KeyName"],
          ),
        );

        final ListChat = await users
            .doc(_currentUser!.email)
            .collection("chats")
            .get();

        if (ListChat.docs.length != 0) {
          List<ChatsUser> dataListChat = [];
          ListChat.docs.forEach((element) {
            var dataChat = element.data();
            var dataChatId = element.id;

            dataListChat.add(
              ChatsUser(
                chatId: dataChatId,
                connection: dataChat["connection"],
                lastTime: dataChat["lastTime"],
                totalUnread: dataChat["total_unread"],
              ),
            );
          });
          user.update((val) {
            val!.chats = dataListChat;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }

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
          });

          await users.doc(_currentUser!.email).collection("chats");
        }

        final userTerkini = await users.doc(_currentUser!.email).get();

        final dataUserTerkini = userTerkini.data() as Map<String, dynamic>;

        user(
          TestUser(
            uid: dataUserTerkini["uid"],
            email: dataUserTerkini["email"],
            name: dataUserTerkini["name"],
            status: dataUserTerkini["status"],
            createdAt: dataUserTerkini["createdAt"],
            updatedAt: dataUserTerkini["updatedAt"],
            photoUrl: dataUserTerkini["photoUrl"],
            lastSignIn: dataUserTerkini["lastSignIn"],
            keyName: dataUserTerkini["KeyName"],
          ),
        );

        final ListChat = await users
            .doc(_currentUser!.email)
            .collection("chats")
            .get();

        if (ListChat.docs.length != 0) {
          List<ChatsUser> dataListChat = [];
          ListChat.docs.forEach((element) {
            var dataChat = element.data();
            var dataChatId = element.id;

            dataListChat.add(
              ChatsUser(
                chatId: dataChatId,
                connection: dataChat["connection"],
                lastTime: dataChat["lastTime"],
                totalUnread: dataChat["total_unread"],
              ),
            );
          });
          user.update((val) {
            val!.chats = dataListChat;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }

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
    if (_currentUser == null) return;

    bool flagNewConnection = false;
    final date = DateTime.now().toIso8601String();

    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    var chat_id;

    final docChats = await users
        .doc(_currentUser!.email)
        .collection("chats")
        .get();

    if (docChats.docs.isNotEmpty) {
      final checkKoneksic = await users
          .doc(_currentUser!.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkKoneksic.docs.isNotEmpty) {
        flagNewConnection = false;
        chat_id = checkKoneksic.docs[0].id;
      } else {
        flagNewConnection = true;
      }
    } else {
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      final cekKoneksiberdua = await chats
          .where(
            "connection",
            whereIn: [
              [_currentUser!.email, friendEmail],
              [friendEmail, _currentUser!.email],
            ],
          )
          .get();

      if (cekKoneksiberdua.docs.isNotEmpty) {
        final chatDataId = cekKoneksiberdua.docs.first.id;
        final chatData =
            cekKoneksiberdua.docs.first.data() as Map<String, dynamic>;

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(chatDataId)
            .set({
              "connection": friendEmail,
              "lastTime": chatData["lastTime"],
              "total_unread": 0,
            });

        chat_id = chatDataId;
        user.refresh();

        Get.toNamed(
          Routes.CHAT,
          parameters: {
            "chatId": chat_id.toString(),
            "FriendEmail": friendEmail,
          },
        );
        return;
      }

      final newChatDocs = await chats.add({
        "connection": [_currentUser!.email, friendEmail],
        "lastTime": date,
      });

      await users
          .doc(_currentUser!.email)
          .collection("chats")
          .doc(newChatDocs.id)
          .set({
            "connection": friendEmail,
            "lastTime": date,
            "total_unread": 0,
          });

      await users.doc(friendEmail).collection("chats").doc(newChatDocs.id).set({
        "connection": _currentUser!.email,
        "lastTime": date,
        "total_unread": 0,
      });

      chat_id = newChatDocs.id;
      user.refresh();
    }

    final updateStatusChat =
        await chats //ambil dari collection chats ambil sub collection chatsnya
            .doc(chat_id)
            .collection("chats")
            .where("isRead", isEqualTo: false) //yang isreaad false
            .where(
              "penerima",
              isEqualTo: _currentUser!.email,
            ) //yang penerima sama dengan user yg login
            .get(); //ambil data

    updateStatusChat.docs.forEach((element) async {
      ///ini dia ngambil data satu persatu
      var updateStatusChat_id = element.id;

      ///ambil idnya si data satu persatu
    await chats.doc(chat_id).collection("chats").doc(updateStatusChat_id).update({
        "isRead": true,
      }); //update isreadnya jadi true
    });

    await users.doc(_currentUser!.email).collection("chats").doc(chat_id).update({ //ini yang di user update total unreadnya
      "total_unread": 0,
    });

    if (chat_id != null) {
      Get.toNamed(
        Routes.CHAT,
        parameters: {"chatId": chat_id.toString(), "FriendEmail": friendEmail},
      );
    }
  }
}
