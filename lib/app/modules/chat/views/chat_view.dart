import 'package:chat_apps/app/controllers/auth_c_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final authC = Get.find<AuthCController>(); //import auth cotnroller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leadingWidth: 100,
        leading: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            return Get.back();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 5),
              Icon(Icons.arrow_back_ios),
              SizedBox(width: 5),
              CircleAvatar(radius: 25, backgroundColor: Colors.black38),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lorem Ipsum",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Statusnnya lorem", style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: Get.width,
              height: Get.height,
              color: const Color.fromARGB(255, 101, 93, 72),
              child: ListView(
                children: [
                  ItemsChat(isSender: true),
                  ItemsChat(isSender: false),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: Get.width,
            height: 100,
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: controller.chatC,
                      focusNode: controller.focusNode,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            controller.focusNode.unfocus();
                            controller.IsShowEmoji.toggle();
                          },
                          icon: Icon(Icons.emoji_emotions_outlined),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 191, 191, 191),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 28, 27, 27),
                            width: 2,
                          ),
                        ),
                        labelText: 'Pesan',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Colors.blue,
                  child: InkWell(
                    child: IconButton(
                      onPressed: () {
                        controller.newChat(
                          authC.user.value.email!,
                          Get.parameters["chatId"]!,
                          Get.parameters["FriendEmail"]!,
                          controller.chatC.text,
                        );

                        controller.chatC.clear(); //opsional: bersihkan input setelah kirim
                      },
                      icon: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Obx(
            () => controller.IsShowEmoji.isTrue
                ? Container(
                    height: 300,
                    child: EmojiPicker(
                      onEmojiSelected: (Category? category, Emoji emoji) {
                        controller.addEmojiToChat(emoji);
                      },

                      onBackspacePressed: () {
                        controller.deleteEmoji();
                      },

                      config: Config(
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          emojiSizeMax: 28,
                          columns: 5,
                        ),
                        viewOrderConfig: const ViewOrderConfig(
                          top: EmojiPickerItem.categoryBar,
                          middle: EmojiPickerItem.emojiView,
                          bottom: EmojiPickerItem.searchBar,
                        ),
                        skinToneConfig: const SkinToneConfig(),
                        categoryViewConfig: const CategoryViewConfig(),
                        bottomActionBarConfig: const BottomActionBarConfig(),
                        searchViewConfig: const SearchViewConfig(),
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

class ItemsChat extends StatelessWidget {
  const ItemsChat({super.key, required this.isSender});

  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment: isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: isSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(isSender ? 10 : 0),
                      bottomRight: Radius.circular(isSender ? 0 : 10),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(isSender ? 0 : 10),
                      topRight: Radius.circular(isSender ? 10 : 0),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
            ),
            child: Text("lorem ipsum dolor sit amet"),
          ),
          Text("12/02/2022"),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
