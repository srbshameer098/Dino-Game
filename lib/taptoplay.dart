import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TapToPlay extends StatelessWidget {
  final bool gameHasStarted;

  const TapToPlay({Key? key, required this.gameHasStarted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return gameHasStarted
        ? Container()
        : Center(
      child: Text(
        'Tap to Play',
        style: TextStyle(fontSize: 24, color: Colors.yellow),
      ),
    );
  }
}

class GameOverScreen extends StatelessWidget {
  final bool gameOver;

  const GameOverScreen({Key? key, required this.gameOver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return gameOver
        ? Center(
      child: Text(
        'Game Over',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    )
        : Container();
  }
}

class ScoreScreen extends StatelessWidget {
  final int score;
  final int highscore;

  const ScoreScreen({Key? key, required this.score, required this.highscore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score: $score',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
          Text(
            'Highscore: $highscore',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class MyDino extends StatelessWidget {
  final double dinoX;
  final double dinoY;
  final double dinoWidth;
  final double dinoHeigth;

  const MyDino({
    Key? key,
    required this.dinoX,
    required this.dinoY,
    required this.dinoWidth,
    required this.dinoHeigth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * dinoX,
      top: MediaQuery.of(context).size.height * dinoY,
      width: MediaQuery.of(context).size.width * dinoWidth,
      height: MediaQuery.of(context).size.height * dinoHeigth,
      child: Image.asset(
        'assets/dino.png', // Path to your dino image
        fit: BoxFit.contain, // Ensures the image fits within the container
      ),
    );
  }
}
class MyBarrier extends StatelessWidget {
  final double barrierX;
  final double barrierY;
  final double barrierWidth;
  final double barrierHeigth;

  const MyBarrier({
    Key? key,
    required this.barrierX,
    required this.barrierY,
    required this.barrierWidth,
    required this.barrierHeigth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * barrierX,
      top: MediaQuery.of(context).size.height * barrierY,
      width: MediaQuery.of(context).size.width * barrierWidth,
      height: MediaQuery.of(context).size.height * barrierHeigth,
      child: Container(
        color: Colors.brown,
      ),
    );
  }
}