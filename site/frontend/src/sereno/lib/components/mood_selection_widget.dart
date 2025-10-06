import 'package:flutter/material.dart';
// ATENÇÃO: Importa o novo modelo, isolando a mudança
import '../models/daily_emotion_data.dart';

/// Widget de seleção de humor animado, usando imagens de asset.
class MoodSelectionWidget extends StatefulWidget {
  final Function(int moodId) onMoodConfirmed;

  const MoodSelectionWidget({super.key, required this.onMoodConfirmed});

  @override
  State<MoodSelectionWidget> createState() => _MoodSelectionWidgetState();
}

class _MoodSelectionWidgetState extends State<MoodSelectionWidget> {
  // Agora usamos DailyEmotionData!
  DailyEmotionData? _selectedEmotion;
  int? _selectedEmotionIdToSave;

  final List<DailyEmotionData> emotions =
      DailyEmotionData.allEmotions; // Lista do novo modelo

  void _selectEmotion(DailyEmotionData emotion) {
    // Usa DailyEmotionData
    setState(() {
      if (_selectedEmotion?.id == emotion.id) {
        _selectedEmotion = null;
        _selectedEmotionIdToSave = null;
      } else {
        _selectedEmotion = emotion;
        _selectedEmotionIdToSave = emotion.id;
        print(
          "Emoção selecionada: ${emotion.emotion} (ID: $_selectedEmotionIdToSave)",
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
    required DailyEmotionData emotion, // Usa DailyEmotionData
    required double top,
    required double left,
    required double size,
  }) {
    final isSelected = _selectedEmotion?.id == emotion.id;
    const double stackSize = 300.0;
    final double centerOffset = (stackSize / 2) - (size / 2);
    // Tamanho da imagem é ligeiramente menor que o Container para padding interno
    // Este padding não será mais visível, mas pode ser útil para o toque.
    final double imageSize = size * 0.8;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      // Se selecionado, move para o centro (centerOffset)
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
              // *** ALTERAÇÃO: REMOVENDO O BACKGROUND COLORIDO ***
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent, // Fundo transparente
                // Mantém apenas o efeito GLOW (sombra colorida) na seleção
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: emotion.color.withOpacity(0.5),
                          blurRadius: 10.0,
                          spreadRadius: 1.0,
                        ),
                      ]
                    : null, // Sem sombra quando não selecionado
              ),
              child: Padding(
                // O padding é mantido para que a área de toque seja maior
                padding: EdgeInsets.all(size * 0.1),
                child: Image.asset(
                  emotion.imagePath,
                  width:
                      size, // Usando 'size' para que a imagem preencha o Container transparente
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

    // Posições baseadas no layout do Figma, mas agora as imagens não têm círculos de fundo
    final Map<String, Offset> finalFigmaPositions = {
      // 1. Indiferente (Topo Central)
      "Indiferente": Offset(center, 0),

      // 2. Feliz (Meio Esquerda)
      "Feliz": Offset(center - 80, center - 20),

      // 3. Raiva (Meio Direita)
      "Raiva": Offset(center + 80, center - 20),

      // 4. Tristeza (Baixo Esquerda)
      "Tristeza": Offset(center - 50, center + 80),

      // 5. Medo (Baixo Direita)
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
