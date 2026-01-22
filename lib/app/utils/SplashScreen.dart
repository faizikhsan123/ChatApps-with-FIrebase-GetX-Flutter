import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; //mengambil ukuran layar
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: size.width * 0.8, //mengatur lebar widget sebesar 80% dari lebar layar
            height: size.height * 0.8, //mengatur tinggi widget sebesar 80% dari tinggi layar
      
            child: Lottie.asset(
              //lottie dibungkus dalam container dan diisi dengan pemanggilan file lottie
              'assets/lottie/dua.json',
            ),
          ),
        ),
      ),
    );
  }
}
