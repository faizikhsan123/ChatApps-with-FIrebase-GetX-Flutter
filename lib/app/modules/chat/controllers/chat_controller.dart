import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var IsShowEmoji = false.obs;

  late FocusNode focusNode; //var focus node

  late TextEditingController chatC; //controller text fied

  void addEmojiToChat(Emoji emoji) { //method untuk menambahkan emoji ke chat
    chatC.text = chatC.text + emoji.emoji;
  }

  void deleteEmoji() {  //method untuk menghapus emoji
    //substring untuk mengambil sebagian teks
    //jadi dia mulainya dari 0 sampai panjang teks dikurangi 2 (karena emoji punya 2 huruf)
    chatC.text = chatC.text.substring(0, chatC.text.length - 2);
  }

  @override
  void onInit() {
    chatC = TextEditingController();
    // TODO: implement onInit
    focusNode = FocusNode();
    focusNode.addListener(() {
      //jika focus node (keyboard) ditekan maka emoji hilang
      if (focusNode.hasFocus) {
        IsShowEmoji.value = false;
      }
    });

    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    chatC.dispose();
    super.dispose();
  }
}
