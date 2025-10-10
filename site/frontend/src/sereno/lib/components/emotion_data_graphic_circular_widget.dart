import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/diario_emotion_data.dart';

class EmotionDoughnutChartWithImageTooltip extends StatefulWidget {
  const EmotionDoughnutChartWithImageTooltip({super.key});

  @override
  State<EmotionDoughnutChartWithImageTooltip> createState() =>
      _EmotionDoughnutChartWithImageTooltipState();
}

class _EmotionDoughnutChartWithImageTooltipState
    extends State<EmotionDoughnutChartWithImageTooltip> {
  late TooltipBehavior _tooltipBehavior;
  String _centerEmotionImagePath = 'assets/images/emoteFeliz.png';

  final List<EmotionData> _chartData = <EmotionData>[
    EmotionData(
      'Feliz',
      45.0,
      Colors.blue.shade300,
      'assets/images/emoteFeliz.png',
    ),
    EmotionData(
      'Raiva',
      5,
      Colors.red.shade700,
      'assets/images/emoteRaiva.png',
    ),
    EmotionData(
      'Triste',
      10,
      Colors.blueGrey.shade400,
      'assets/images/emoteTristeza.png',
    ),
    EmotionData(
      'Medo',
      5,
      const Color(0xFF4B3A80),
      'assets/images/emoteMedo.png',
    ),
    EmotionData(
      'Indiferente',
      35,
      Colors.lightGreen.shade400,
      'assets/images/emoteIndiferente.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _centerEmotionImagePath = _getPredominantEmotion().imagePath;

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      duration: 0,
      builder:
          (
            dynamic dataPoint,
            dynamic point,
            dynamic series,
            int pointIndex,
            int seriesIndex,
          ) {
            _updateCenterEmotion(pointIndex);
            final EmotionData data = _chartData[pointIndex];
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
                  Image.asset(data.imagePath, height: 40, width: 40),
                  const SizedBox(height: 8),
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

  EmotionData _getPredominantEmotion() {
    return _chartData.reduce((a, b) => a.percentage > b.percentage ? a : b);
  }

  void _updateCenterEmotion(int pointIndex) {
    String newImagePath;
    if (pointIndex < 0 || pointIndex >= _chartData.length) {
      newImagePath = _getPredominantEmotion().imagePath;
    } else {
      newImagePath = _chartData[pointIndex].imagePath;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _centerEmotionImagePath = newImagePath;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SfCircularChart(
              tooltipBehavior: _tooltipBehavior,

              onChartTouchInteractionUp: (_) {
                _updateCenterEmotion(-1);
              },
              series: <CircularSeries>[
                DoughnutSeries<EmotionData, String>(
                  enableTooltip: true,
                  dataSource: _chartData,
                  xValueMapper: (EmotionData data, _) => data.emotion,
                  yValueMapper: (EmotionData data, _) => data.percentage,
                  pointColorMapper: (EmotionData data, _) => data.color,
                  innerRadius: '65%',
                  strokeWidth: 0,

                  onPointTap: (ChartPointDetails details) {
                    _updateCenterEmotion(details.pointIndex!);
                  },
                ),
              ],
            ),
            if (_centerEmotionImagePath.isNotEmpty)
              Image.asset(_centerEmotionImagePath, height: 70, width: 70),
          ],
        ),
      ),
    );
  }
}
