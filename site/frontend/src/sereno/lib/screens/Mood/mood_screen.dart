import 'package:flutter/material.dart';
import '../../service/api_service.dart';

class MoodScreen extends StatefulWidget {
  final int userId;
  const MoodScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  MoodType? _selectedMood;
  bool _isLoading = false;
  final _apiService = ApiService();

  final Map<MoodType, String> moodImages = {
    MoodType.FELIZ: 'assets/images/emoteFeliz.png',
    MoodType.INDIFERENTE: 'assets/images/emoteIndiferente.png',
    MoodType.RAIVA: 'assets/images/emoteRaiva.png',
    MoodType.TRISTEZA: 'assets/images/emoteTristeza.png',
    MoodType.MEDO: 'assets/images/emoteMedo.png',
  };

  void _submitMood() async {
    if (_selectedMood == null) return;
    setState(() => _isLoading = true);

    final success = await _apiService.submitMood(userId: widget.userId, mood: _selectedMood!);
    
    if(mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Humor registrado com sucesso!' : 'Ocorreu um erro.'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if(success) {
        Navigator.of(context).pop(); 
      }
    }
     setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3C7F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/emoteFeliz.png', height: 40),
                        const SizedBox(width: 10),
                        Text('Sereno', style: TextStyle(fontSize: 36, color: Colors.deepPurple[800], fontWeight: FontWeight.bold)),
                      ],
                    ),
                  const SizedBox(height: 40),
                  Text('Como você está hoje?', style: TextStyle(fontSize: 28, color: Colors.deepPurple[800], fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Toque para gravar o humor', style: TextStyle(fontSize: 16)),
                ],
              ),
              Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                alignment: WrapAlignment.center,
                children: moodImages.entries.map((entry) {
                  return _buildMoodEmote(entry.key, entry.value);
                }).toList(),
              ),
              _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _selectedMood == null ? null : _submitMood,
                    child: const Text('Confirmar'),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodEmote(MoodType mood, String imagePath) {
    final bool isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: Opacity(
        opacity: isSelected || _selectedMood == null ? 1.0 : 0.5,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.deepPurple[200] : Colors.transparent,
              ),
              child: Image.asset(imagePath, height: 70),
            ),
            const SizedBox(height: 8),
            Text(mood.toString().split('.').last, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}