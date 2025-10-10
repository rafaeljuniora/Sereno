import 'dart:async';
import 'package:flutter/material.dart';

class FireStreakAnimation extends StatefulWidget {
  final double width;
  final double height;

  const FireStreakAnimation({super.key, this.width = 24, this.height = 24});

  @override
  State<FireStreakAnimation> createState() => _FireStreakAnimationState();
}

class _FireStreakAnimationState extends State<FireStreakAnimation> {
  final List<String> _frames = [
    'assets/images/foguinho1.png',
    'assets/images/foguinho2.png',
    'assets/images/foguinho3.png',
    'assets/images/foguinho4.png',
    'assets/images/foguinho5.png',
  ];

  int _currentFrame = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Troca a imagem a cada 100ms (10 frames por segundo)
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _currentFrame = (_currentFrame + 1) % _frames.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Image.asset(
        _frames[_currentFrame],
        width: widget.width,
        height: widget.height,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) {
          // Caso a imagem não carregue, mostra um container transparente
          return Container(width: widget.width, height: widget.height);
        },
      ),
    );
  }
}
