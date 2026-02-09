import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;
  late ImagePicker imagePicker = ImagePicker(); //import image_picker

  XFile? pickedImage = null; //untuk menampung gambar

void selectImage() async {
  try {
    final dataImage = await imagePicker.pickImage(source: ImageSource.gallery); //pas function ini dijalankan otomatis buka galeri dan dia juga dapaat data gambarnya

    if (dataImage != null) { //kalo user berhasil memilih gambar
    // print(dataImage!.path);
    // print(dataImage!.name);

    pickedImage = dataImage;
    }
    update(); //untuk memperbarui tampilan (karena make get builder)

  } catch (e) {  //kalo user klik cancel pada pemilihan gamabar
    print(e);
    pickedImage = null;
    update(); //untuk memperbarui tampilan (karena make get builder)
    
  }
 
}


void deleteImage() async { //untuk menghapus gambar
  pickedImage = null;
  update(); //untuk memperbarui tampilan (karena make get builder)
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
