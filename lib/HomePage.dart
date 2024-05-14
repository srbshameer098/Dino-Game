import 'dart:async';

import 'package:dino/dino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // dino variables (out of 2)
  double dinoX = -0.5;
  double dinoY = 1;
  double dinoWidth = 0.2;
  double dinoHeigth = 0.4;

  // barrier variables (out of 2)
  double barrierX = 1;
  double barrierY = 1;
  double barrierWidth = -0.1;
  double barrierHeigth = -0.4;

  // jump variables
  double time = 0;
  double height = 0;
  double gravity = 9.8;
  double velocity = 5;

  // game settings
  bool gameHasStarted = false;
  bool midJump = false;

  bool gameOver = false;
  int score = 0;
  int highscore = 0;
  bool dinoPassedBarrier = false;

  //  startGame
  void startGame() {
    setState(() {
      gameHasStarted = true;
    });
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (detectCollision()) {
        gameOver = true;
        timer.cancel();
        setState(() {
          if (score > highscore) {
            highscore = score;
          }
        });
      }
    });
  }

  //  updateScore
  void updateScore() {}

  //  loopBarriers
  void loopBarriers() {
    setState(() {
      if (barrierX <= -1.2) {
        barrierX = 1.2;
        dinoPassedBarrier = false;
      }
    });
  }

  //  Barriers Collision detection
  bool detectCollision() {}

  // dino jump
  void jump() {
    midJump = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height = -gravity / 2 * time * time + velocity * time;

      setState(() {
        if (1 - height > 1) {
          resetjump();
          dinoY = 1;
          timer.cancel();
        } else {
          dinoY = 1 - height;
        }
      });

      if (gameOver) {
        timer.cancel();
      }
      time += 0.01;
    });
  }

  // resetjump
  void resetjump() {}

  // playAgain
  void playAgain() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameOver
          ? (playAgain)
          : (gameHasStarted ? (midJump ? null : jump) : startGame),
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  color: Colors.red,
                  child: Center(
                    child: Stack(
                      children: [
                        //  Tap To Play
                        TapToPlay(
                          gameHasStarted: gameHasStarted,
                        ),
                        GameOverScreen(
                          gameOver: gameOver,
                        ),

                        ScoreScreen(
                          score: score,
                          highscore: highscore,
                        ),

                        MyDino(
                            dinoX: dinoX,
                            dinoY: dinoY,
                            dinoWidth: dinoWidth,
                            dinoHeigth: dinoHeigth),

                        MyBarrier(
                            barrierX: barrierX,
                            barrierY: barrierY - barrierHeigth,
                            barrierWidth: barrierWidth,
                            barrierHeigth: barrierHeigth),



                      ],
                    ),
                  ),
                )),
            Expanded(
                child: Container(
              color: Colors.blue,
            ))
          ],
        ),
      ),
    );
  }
}
