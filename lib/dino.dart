import 'package:flutter/material.dart';

class MyDino extends StatelessWidget {
  final double dinoX;
  final double dinoY;
  final double dinoWidth;
  final double dinoHeigth;

  const MyDino({
    super.key,
    required this.dinoX,
    required this.dinoY,
    required this.dinoWidth,
    required this.dinoHeigth,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * dinoX,
      top: MediaQuery.of(context).size.height * dinoY,
      width: MediaQuery.of(context).size.width * dinoWidth,
      height: MediaQuery.of(context).size.height * dinoHeigth,
      child: Image.asset(
        'assets/dino.png',
        fit: BoxFit.fill,
      ),
    );
  }
}