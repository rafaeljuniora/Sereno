import 'package:flutter/material.dart';
import '../../components/emotion_data_widget.dart';

class EmotionChartTestScreen extends StatelessWidget {
  const EmotionChartTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Gráfico de Emoções'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(child: EmotionDoughnutChartWithImageTooltip()),
    );
  }
}
