import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'barrier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double dinoX = -0.005;
  double dinoY = -0.5;
  double dinoWidth = 0.00002;
  double dinoHeight = 0.00002;

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
  bool isPaused = false; // Track if game is paused
  int score = 0;
  int highscore = 0;
  bool dinoPassedBarrier = false;
  double speed = 0.05;

  Timer? gameTimer;
  final AudioPlayer jumpSound = AudioPlayer();
  final AudioPlayer collisionSound = AudioPlayer();

  void startGame() {
    gameHasStarted = true;
    isPaused = false;
    gameTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!isPaused) {
        setState(() {
          barrierX -= speed;
        });

        if (barrierX < -1.2) {
          barrierX = 1.2;
          barrierHeight = 0.4 + Random().nextDouble() * 0.4;
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
          collisionSound.play(AssetSource("game-over.mp3"));
          timer.cancel();
        }
      }
    });
  }

  void pauseGame() {
    setState(() {
      isPaused = true;
    });
  }

  void resumeGame() {
    setState(() {
      isPaused = false;
    });
  }

  bool detectCollision() {
    return (dinoX + dinoWidth > barrierX &&
        dinoX < barrierX + barrierWidth &&
        dinoY + dinoHeight > 0.9 - barrierHeight);
  }

  void jump() {
    if (isPaused || gameOver) return;
    midJump = true;
    time = 0.00005;
    jumpSound.play(AssetSource("jump-up.mp3"));
    Timer.periodic(Duration(milliseconds: 5), (timer) {
      if (!isPaused) {
        height = -gravity / 1.65 * time * time + velocity * time;
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
      }
    });
  }

  void playAgain() {
    setState(() {
      gameOver = false;
      gameHasStarted = false;
      isPaused = false;
      dinoX = -0.005;
      dinoY = -0.5;
      time = 0;
      midJump = false;
      barrierX = 1.2;
      barrierHeight = 0.4;
      score = 0;
      speed = 0.05;
    });
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameOver
          ? playAgain
          : (gameHasStarted ? (midJump ? null : jump) : startGame),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: [
            // Moving Background
            Positioned.fill(
                child: MovingBackground(
                  gameOver: gameOver || isPaused,
                )),

            // Dino
            Positioned(
              left: MediaQuery.of(context).size.width * dinoX,
              top: MediaQuery.of(context).size.height * dinoY,
              child: Image.asset(
                "assets/dino00.png",
                width: 80,
                height: 80,
              ),
            ),

            // Barrier
            Positioned(
              left: MediaQuery.of(context).size.width * barrierX,
              bottom: -0.1,
              child: Image.asset(
                "assets/Cactus.png",
                width: MediaQuery.of(context).size.width * barrierWidth,
                height: MediaQuery.of(context).size.height * barrierHeight,
              ),
            ),

            // Ground
            Positioned.fill(
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 30,
                  color: Colors.green,
                ),
              ),
            ),

            // Game Over or Tap to Start Message
            Center(
              child: gameOver
                  ? Text("Game Over",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 50,
                      fontWeight: FontWeight.w900))
                  : (!gameHasStarted
                  ? Text("Tap to Start",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 40,
                      fontWeight: FontWeight.w700))
                  : Container()),
            ),

            // Score Display
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Score: $score",
                      style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w600)),
                  Text("Highscore: $highscore",
                      style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            // Pause & Resume Buttons
            Positioned(
              top: 20,
              right: 20,
              child: gameHasStarted && !gameOver
                  ? IconButton(
                icon: Icon(
                  isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () {
                  if (isPaused) {
                    resumeGame();
                  } else {
                    pauseGame();
                  }
                },
              )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
