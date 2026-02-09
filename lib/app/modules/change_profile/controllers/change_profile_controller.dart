import 'package:chat_apps/app/controllers/auth_c_controller.dart';
import 'package:chat_apps/app/data/models/test_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert';


class ChangeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;
  late ImagePicker imagePicker = ImagePicker();

  String? imageUrl; // untuk menyimpan url gambar

  var user = TestUser().obs; //import models nya


  XFile? pickedImage = null; 

   FirebaseFirestore firestore = FirebaseFirestore.instance; 

   final authC = Get.find<AuthCController>();


  void selectImage() async {
    try {
      final dataImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (dataImage != null) {
        pickedImage = dataImage;
      }
      update();
    } catch (e) {
      print(e);
      pickedImage = null;
      update();
    }
  }

  void deleteImage()  {
    pickedImage = null;
    update();
  }

  //upload iamge to cloudinary
  
Future<void> uploadImageToCloudinary(String email) async {
  if (pickedImage == null) return;

  try {
    String cloudName = "dvjnnntun"; //cloudname kita di cloudinary
    String uploadPreset = "chatApp"; //upload preset kita di cloudinary

    var uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest("POST", uri);

    request.fields['upload_preset'] = uploadPreset; //upload preset

    request.files.add( ////kirim gambar
      await http.MultipartFile.fromPath( 
        'file', 
        pickedImage!.path, //path gambar
      ),
    );

    var response = await request.send(); //kirim request
    var resData = await response.stream.toBytes(); //ambil data
    var result = jsonDecode(String.fromCharCodes(resData)); //ubah ke json

    imageUrl = result['secure_url']; //ambil url

    CollectionReference users = firestore.collection("users");

    await users.doc(email).update({
      "photoUrl" : imageUrl //update yg ada di firebase dengan url gambar dari cloudinary
    });

    print("UPLOAD BERHASIL: $imageUrl");

    //setealah update dari firestore update juga modelnya
    authC.user.update((val) {
    val!.photoUrl = imageUrl;
    });


    Get.defaultDialog(
      title: "Success",
      middleText: "Update profile success",
      onConfirm: () {
        Get.back();
      },
    );

    // reset gambar lokal supaya preview hilang
    pickedImage = null;

    update();
  } catch (e) {
    print("UPLOAD ERROR: $e");
  }
}

  @override
  void onInit() {
    emailC = TextEditingController();
    nameC = TextEditingController();
    statusC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    nameC.dispose();
    statusC.dispose();

    super.onClose();
  }
}
