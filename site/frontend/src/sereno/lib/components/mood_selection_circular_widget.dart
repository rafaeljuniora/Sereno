import 'package:flutter/material.dart';
import '../models/daily_emotion_data.dart';
import '../service/api_service.dart';

class MoodSelectionWidget extends StatefulWidget {
  final Function(int moodId) onMoodConfirmed;

  const MoodSelectionWidget({super.key, required this.onMoodConfirmed});

  @override
  State<MoodSelectionWidget> createState() => _MoodSelectionWidgetState();
}

class _MoodSelectionWidgetState extends State<MoodSelectionWidget> {
  DailyEmotionData? _selectedEmotion;
  int? _selectedEmotionIdToSave;

  final List<DailyEmotionData> emotions = DailyEmotionData.allEmotions;

  void _selectEmotion(DailyEmotionData emotion) {
    setState(() {
      if (_selectedEmotion?.id == emotion.id) {
        _selectedEmotion = null;
        _selectedEmotionIdToSave = null;
      } else {
        _selectedEmotion = emotion;
        _selectedEmotionIdToSave = emotion.id;
        print(
          "Emoção selecionada: ${emotion.emotion} (ID: $_selectedEmotionIdToSave) token: ${ApiService.authToken}",
        );
      }
    });
  }

  void _confirmMood() {
    if (_selectedEmotionIdToSave != null) {
      widget.onMoodConfirmed(_selectedEmotionIdToSave!);
    }
  }

  Widget _buildEmotionItem({
    required DailyEmotionData emotion,
    required double top,
    required double left,
    required double size,
  }) {
    final isSelected = _selectedEmotion?.id == emotion.id;
    const double stackSize = 300.0;
    final double centerOffset = (stackSize / 2) - (size / 2);

    final double imageSize = size * 0.8;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,

      top: isSelected ? centerOffset : top,
      left: isSelected ? centerOffset : left,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _selectEmotion(emotion),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: size,
              height: size,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,

                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: emotion.color.withOpacity(0.5),
                          blurRadius: 10.0,
                          spreadRadius: 1.0,
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.all(size * 0.1),
                child: Image.asset(
                  emotion.imagePath,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              emotion.emotion,
              style: TextStyle(
                color: isSelected ? emotion.color : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double stackSize = 300.0;
    const double emotionItemSize = 70.0;
    const double center = (stackSize - emotionItemSize) / 2;

    final Map<String, Offset> finalFigmaPositions = {
      "Indiferente": Offset(center, 0),

      "Feliz": Offset(center - 80, center - 20),

      "Raiva": Offset(center + 80, center - 20),

      "Tristeza": Offset(center - 50, center + 80),

      "Medo": Offset(center + 50, center + 80),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Como você está hoje?",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Toque para gravar o humor",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 30),

        SizedBox(
          width: stackSize,
          height: stackSize,
          child: Stack(
            children: [
              for (var emotion in emotions)
                _buildEmotionItem(
                  emotion: emotion,
                  top: finalFigmaPositions[emotion.emotion]!.dy,
                  left: finalFigmaPositions[emotion.emotion]!.dx,
                  size: emotionItemSize,
                ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        ElevatedButton(
          onPressed: _selectedEmotionIdToSave == null ? null : _confirmMood,
          child: const Text("Confirmar Humor"),
        ),
      ],
    );
  }
}
