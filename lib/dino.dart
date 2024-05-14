import 'package:flutter/material.dart';

class MyDino extends StatelessWidget {
  final double dinoX;

  final double dinoY;

  final double dinoWidth;

  final double dinoHeigth;

  const MyDino(
      {super.key,
      required this.dinoX,
      required this.dinoY,
      required this.dinoWidth,
      required this.dinoHeigth});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * dinoX + dinoWidth) / (2 - dinoHeigth),
          (2 * dinoY + dinoHeigth) / (2 - dinoHeigth)),
      child: Container(
        height: MediaQuery.of(context).size.height * 2 / 3 * dinoHeigth,
        width: MediaQuery.of(context).size.width * dinoWidth / 2,
        child: Image.asset(
          'assets/dino.png',
            fit:  BoxFit.fill,),
      ),
    );
  }
}
