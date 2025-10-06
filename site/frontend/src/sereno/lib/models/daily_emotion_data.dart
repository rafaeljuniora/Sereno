import 'package:flutter/material.dart';

// O caminho para o asset deve ser um caminho válido no seu pubspec.yaml
const String _baseImagePath = 'assets/images/';

// Classe de dados para o seletor de humor, garantindo que o ID esteja presente.
class DailyEmotionData {
  final int id;
  final String emotion;
  final double percentage;
  final Color color;
  final String imagePath;

  DailyEmotionData({
    required this.id,
    required this.emotion,
    required this.percentage,
    required this.color,
    required this.imagePath,
  });

  // Lista estática de dados para este componente específico
  static List<DailyEmotionData> get allEmotions => [
    // ATENÇÃO: Substitua 'nome_do_arquivo.png' pelos nomes reais dos seus assets.
    DailyEmotionData(
      id: 1,
      emotion: "Feliz",
      percentage: 0.2,
      color: const Color(0xFF8e44ad),
      imagePath: '${_baseImagePath}emoteFeliz.png',
    ),
    DailyEmotionData(
      id: 2,
      emotion: "Indiferente",
      percentage: 0.1,
      color: Colors.green,
      imagePath: '${_baseImagePath}emoteIndiferente.png',
    ),
    DailyEmotionData(
      id: 3,
      emotion: "Raiva",
      percentage: 0.3,
      color: Colors.red,
      imagePath: '${_baseImagePath}emoteRaiva.png',
    ),
    DailyEmotionData(
      id: 4,
      emotion: "Tristeza",
      percentage: 0.2,
      color: Colors.blueGrey,
      imagePath: '${_baseImagePath}emoteTristeza.png',
    ),
    DailyEmotionData(
      id: 5,
      emotion: "Medo",
      percentage: 0.2,
      color: Colors.deepPurple,
      imagePath: '${_baseImagePath}emoteMedo.png',
    ),
  ];
}
