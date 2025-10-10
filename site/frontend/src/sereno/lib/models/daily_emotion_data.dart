import 'package:flutter/material.dart';

const String _baseImagePath = 'assets/images/';

class DailyEmotionData {
  final int id;
  final String emotion;
  final Color color;
  final String imagePath;

  DailyEmotionData({
    required this.id,
    required this.emotion,
    required this.color,
    required this.imagePath,
  });

  static List<DailyEmotionData> get allEmotions => [
    DailyEmotionData(
      id: 1,
      emotion: "Feliz",
      color: const Color(0xFF8e44ad),
      imagePath: '${_baseImagePath}emoteFeliz.png',
    ),
    DailyEmotionData(
      id: 2,
      emotion: "Indiferente",
      color: Colors.green,
      imagePath: '${_baseImagePath}emoteIndiferente.png',
    ),
    DailyEmotionData(
      id: 3,
      emotion: "Raiva",
      color: Colors.red,
      imagePath: '${_baseImagePath}emoteRaiva.png',
    ),
    DailyEmotionData(
      id: 4,
      emotion: "Tristeza",
      color: Colors.blueGrey,
      imagePath: '${_baseImagePath}emoteTristeza.png',
    ),
    DailyEmotionData(
      id: 5,
      emotion: "Medo",
      color: Colors.deepPurple,
      imagePath: '${_baseImagePath}emoteMedo.png',
    ),
  ];
}
