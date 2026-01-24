import 'package:chat_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/cari_controller.dart';

class CariView extends GetView<CariController> {
  Widget build(BuildContext context) {
    final List<Widget> friends = List.generate(
      //buar list widget dengan nama friends
      20,
      (index) => ListTile(
        leading: CircleAvatar(),
        title: Text(
          "Orang ke ${index + 1}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "orang ke ${index + 1} @gmail.com",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        trailing: GestureDetector(
          //chip dibungkus dalam gesture detector agar bisa di klik
          onTap: () {
            Get.toNamed(Routes.CHAT,);
          },
          child: Chip(label: Text("message")),
        ),
      ),
    );
    return Scaffold(
      appBar: PreferredSize(
        // prefferredSize widget pembungkus yang dipakai untuk menentukan ukuran (biasanya tinggi) dari widget yang dipasang di AppBar.
        child: AppBar(
          //appbar dibungkus dalam preferredsize agar ukuran appbar bisa dicustom
          backgroundColor: Color.fromARGB(255, 64, 61, 61),
          title: Text('Search'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back),
          ),
          flexibleSpace: Align(
            //flexible space untuk buat widget di ruang tersisa nya appbar
            alignment: AlignmentGeometry
                .bottomCenter, // dipakai buat mengatur posisi (alignment) sebuah widget di dalam parent-nya (appbar di sini)
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: Colors.amber,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    //untuk border ketika di focus atau lagi di klik
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Cari orang',
                  suffixIcon: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: Icon(Icons.search, color: Colors.amber),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(
          140,
        ), //ukuran widget (appbar) yg dibungkus preferredsize
      ),
      body: Expanded(
        child:
            friends.length == 0 //jika tidak ada teman yg ditemukan tampilkan lottie ini
            ? Center(
                child: Container(
                  width: Get.width * 0.8,
                  height: Get.height * 0.8,
                  child: Lottie.asset('assets/lottie/kosong.json'),
                ),
              )
            : ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) => friends[index],
                padding: EdgeInsets.zero,
              ),
      ),
    );
  }
}
