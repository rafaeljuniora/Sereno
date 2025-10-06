import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/emotion_data.dart'; // Certifique-se de que o caminho está correto

class EmotionDoughnutChartWithImageTooltip extends StatefulWidget {
  const EmotionDoughnutChartWithImageTooltip({super.key});

  @override
  State<EmotionDoughnutChartWithImageTooltip> createState() =>
      _EmotionDoughnutChartWithImageTooltipState();
}

class _EmotionDoughnutChartWithImageTooltipState
    extends State<EmotionDoughnutChartWithImageTooltip> {
  late TooltipBehavior _tooltipBehavior;
  
  // Variável de Estado para a Imagem Central Dinâmica
  String _centerEmotionImagePath = 'assets/images/emoteFeliz.png'; 
  
  // Variável para rastrear o índice da última interação e prevenir o flicker.
  int _lastInteractedIndex = -1; 

  // --- DADOS DO GRÁFICO: CORES CORRIGIDAS BASEADO NOS SEUS COMENTÁRIOS ---
  final List<EmotionData> _chartData = <EmotionData>[
    // 1. FELIZ (45%) -> Azul Claro (Mantido, pois é o tom correto)
    EmotionData('Feliz', 45, Colors.blue.shade300, 'assets/images/emoteFeliz.png'),
    // 2. RAIVA (5%) -> Vermelho Escuro (Mantido, pois é o tom correto)
    EmotionData('Raiva', 5, Colors.red.shade700, 'assets/images/emoteRaiva.png'),
    // 3. TRISTE (10%) -> CINZA (Corrigido de Verde)
    EmotionData('Triste', 10, Colors.blueGrey.shade400, 'assets/images/emoteTristeza.png'),
    // 4. MEDO (5%) -> ROXO (Corrigido de Laranja)
    EmotionData('Medo', 5, const Color(0xFF4B3A80), 'assets/images/emoteMedo.png'),
    // 5. INDIFERENTE (35%) -> VERDE (Corrigido de Roxo/Cor original)
    EmotionData('Indiferente', 35, Colors.lightGreen.shade400, 'assets/images/emoteIndiferente.png'),
  ];

  @override
  void initState() {
    super.initState();

    // Define a emoção inicial baseada no primeiro item da lista
    if (_chartData.isNotEmpty) {
      _centerEmotionImagePath = _chartData.first.imagePath;
      _lastInteractedIndex = 0;
    }
    
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      duration: 0,
      
      builder: (dynamic dataPoint, dynamic point, dynamic series,
          int pointIndex, int seriesIndex) {
        
        // Chama a função de atualização aqui para lidar com o HOVER (desktop)
        _updateCenterEmotion(pointIndex); 
        
        final EmotionData data = _chartData[pointIndex];
        
        // Retorna o Widget customizado para o Tooltip (o popup flutuante)
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: <Widget>[
              // Imagem da emoção no Tooltip
              Image.asset(data.imagePath, height: 40, width: 40),
              const SizedBox(height: 8),
              // Texto da emoção e porcentagem
              Text(
                '${data.emotion}: ${data.percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Lógica para atualizar a imagem central com BLOQUEIO DE REDESENHO
  void _updateCenterEmotion(int pointIndex) {
    if (pointIndex < 0 || pointIndex >= _chartData.length) return;
    
    // IMPORTANTE: Bloqueia o setState se a emoção atual for a mesma da última interação.
    if (pointIndex == _lastInteractedIndex) {
      return; 
    }
    
    final newImagePath = _chartData[pointIndex].imagePath;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _centerEmotionImagePath = newImagePath;
        _lastInteractedIndex = pointIndex; // Atualiza o índice da última interação
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Stack( // Permite sobrepor a imagem no centro
          alignment: Alignment.center,
          children: [
            // 1. O GRÁFICO DE ROSCA
            SfCircularChart(
              tooltipBehavior: _tooltipBehavior,
              
              series: <CircularSeries>[
                DoughnutSeries<EmotionData, String>(
                  enableTooltip: true,
                  dataSource: _chartData,
                  xValueMapper: (EmotionData data, _) => data.emotion,
                  yValueMapper: (EmotionData data, _) => data.percentage,
                  pointColorMapper: (EmotionData data, _) => data.color, 
                  innerRadius: '65%', // Torna-o um gráfico de rosca
                  strokeWidth: 0,
                  
                  // onPointTap
                  onPointTap: (ChartPointDetails details) {
                    // Chama a função de atualização no toque/clique
                    _updateCenterEmotion(details.pointIndex!);
                  },
                ),
              ],
            ),
            // 2. A IMAGEM CENTRAL DINÂMICA
            if (_centerEmotionImagePath.isNotEmpty) 
              Image.asset(
                _centerEmotionImagePath, // Usa a variável de estado dinâmica
                height: 70, 
                width: 70,
              ),
          ],
        ),
      ),
    );
  }
}