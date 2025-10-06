import 'package:flutter/material.dart';

class EmotionData {
  final String emotion;
  final double percentage;
  final Color color;
  final String imagePath; // Caminho para o asset da imagem

  EmotionData(this.emotion, this.percentage, this.color, this.imagePath);
}
