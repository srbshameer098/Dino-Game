import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double dinoX = -0.0005;
  double dinoY= -0.5;
  double dinoWidth = 0.2;
  double dinoHeight = 0.2;

  double barrierX = 1.2;
  double barrierWidth = 0.1;
  double barrierHeight = 0.3;

  double time = 0;
  double height = 0;
  double gravity = 9.8;
  double velocity = 5;

  bool gameHasStarted = false;
  bool midJump = false;
  bool gameOver = false;
  int score = 0;
  int highscore = 0;
  bool dinoPassedBarrier = false;
  double speed = 0.05;

  final AudioPlayer jumpSound = AudioPlayer();
  final AudioPlayer collisionSound = AudioPlayer();

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        barrierX -= speed;
      });

      if (barrierX < -1.2) {
        barrierX = 1.2;
        barrierHeight = 0.3 + Random().nextDouble() * 0.4;
        dinoPassedBarrier = false;
        score++;
        if (score > highscore) {
          highscore = score;
        }
        if (score % 5 == 0) {
          speed += 0.005;
        }
      }

      if (detectCollision()) {
        gameOver = true;
        collisionSound.play(AssetSource("collision.mp3"));
        timer.cancel();
      }
    });
  }

  bool detectCollision() {
    return (dinoX + dinoWidth > barrierX &&
        dinoX < barrierX + barrierWidth &&
        dinoY + dinoHeight > 1 - barrierHeight);
  }

  void jump() {
    midJump = true;
    time = 0.00005;
    jumpSound.play(AssetSource("jump.mp3"));
    Timer.periodic(Duration(milliseconds: 5), (timer) {
      height = -gravity / 2 * time * time + velocity * time;
      setState(() {
        if (1 - height > 1) {
          dinoY = 0.5;
          midJump = false;
          timer.cancel();
        } else {
          dinoY = 1 - height;
        }
      });
      if (gameOver) timer.cancel();
      time += 0.01;
    });
  }

  void playAgain() {
    setState(() {
      gameOver = false;
      gameHasStarted = false;
      dinoX =  -0.0005;
      dinoY = -0.5;
      time = 0; // Reset jump physics
      midJump = false; // Ensure it's not stuck in a jump
      barrierX = 1.2;
      barrierHeight = 0.4; // Reset obstacle height
      score = 0;
      speed = 0.05;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameOver ? playAgain : (gameHasStarted ? (midJump ? null : jump) : startGame),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/bg.png", fit: BoxFit.cover),
            ),
            Positioned(

              left: MediaQuery.of(context).size.width * dinoX,
              top: MediaQuery.of(context).size.height * dinoY,
              child: Image.asset("assets/dino-game.png"),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * barrierX,
              bottom: -0.1,
              child: Image.asset(
                "assets/Cactus.png",
                width: MediaQuery.of(context).size.width * barrierWidth,
                height: MediaQuery.of(context).size.height * barrierHeight,
              ),
            ),

            Positioned.fill(
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 20,
                  color: Colors.green,
                ),
              ),
            ),
            Center(
              child: gameOver ? Text("Game Over", style: TextStyle(color: Colors.red, fontSize: 30)) :
              (!gameHasStarted ? Text("Tap to Start", style: TextStyle(color: Colors.green, fontSize: 24,fontWeight: FontWeight.w700)) : Container()),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Score: $score", style: TextStyle(fontSize: 20, color: Colors.black)),
                  Text("Highscore: $highscore", style: TextStyle(fontSize: 20, color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
