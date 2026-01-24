import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final List<Widget> myChats = List.generate(
    //buat List mycharts bertipe widget  untuk dipakai di ListView.builder ? (baca penjelasan dibawah)
    20, //data sebanyak 20
    (index) => ListTile(
      onTap: () {
        Get.toNamed(Routes.CHAT); //keatika di tap langsung ke chat per orng
      }, //ketika di tap
      leading: CircleAvatar(),
      title: Text(
        "Orang ke ${index + 1}",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "Status  ke ${index + 1}",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      //widget trailing untuk di kanan bagian leading
      trailing: Chip(
        ///widget chip untuk membuat badge
        label: Text("3"),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            //widget material seperti “kertas putih yang ngambang”
            elevation: 6, //untuk membuat shadow + ngamban
            child: Container(
              margin: EdgeInsets.only(
                top: context
                    .mediaQuery
                    .padding
                    .top, //margin atas nilainya dari mediaquery (getx)
              ),
              padding: const EdgeInsets.only(
                left: 20,
                right: 30,
                top: 20,
                bottom: 20,
              ),
              color: Colors.amberAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chats",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Material(
                    color: Colors.red,
                    shape: CircleBorder(),
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        Get.toNamed(Routes.PROFILE); //pindah page ke profile
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: myChats.length, //ambil dari widget myChats diatas
              itemBuilder: (context, index) => myChats[index], //return widget myChats diatas sesuuai index
              padding: EdgeInsets.zero, //menghilangkan padding bawaan listview
              reverse:true, //jadi widget yang diambil dair myChats diatas akan diurutkan secara terbalik
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.CARI);
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.search,size: 30,color: Colors.white,),
      ),
    );
  }
}
