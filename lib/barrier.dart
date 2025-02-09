import 'package:flutter/material.dart';

class MovingBackground extends StatefulWidget {
  final bool gameOver; // Receive gameOver state

  const MovingBackground({Key? key, required this.gameOver}) : super(key: key);

  @override
  _MovingBackgroundState createState() => _MovingBackgroundState();
}

class _MovingBackgroundState extends State<MovingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 50),
    )..addListener(() {
      setState(() {
        _offset -= 5;
        if (_offset < -MediaQuery.of(context).size.width) {
          _offset = 0;
        }
      });
    });
    _controller.repeat();
  }

  @override
  void didUpdateWidget(MovingBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.gameOver) {
      _controller.stop(); // Stop animation on game over
    } else {
      _controller.repeat(); // Resume animation when game restarts
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _offset,
          child: Image.asset(
            'assets/bg.png',
            width: MediaQuery.of(context).size.width * 2,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
