import 'package:flutter/material.dart';
import '../../components/emotion_data_widget'; // Ajuste o caminho conforme sua estrutura

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
      body: const Center(
        // Este é o componente que você criou
        child: EmotionDoughnutChartWithImageTooltip(),
      ),
    );
  }
}
