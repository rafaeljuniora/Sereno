import 'package:flutter/material.dart';
import '../../service/api_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../../components/mood_selection_circular_widget.dart';

class MoodScreen extends StatefulWidget {
  final int userId;
  const MoodScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  bool _isLoading = true;
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkMoodStatus();
  }

  Future<void> _checkMoodStatus() async {
    try {
      final alreadySubmitted = await _apiService.hasSubmittedMoodToday(
        userId: widget.userId,
      );

      if (!mounted) return;

      if (alreadySubmitted) {
        final avatarId = await _apiService.getMyAvatarId();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                DashboardScreen(avatarId: avatarId ?? 2, userId: widget.userId),
          ),
        );
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitMood(int moodId) async {
    setState(() => _isLoading = true);

    MoodType? mood;
    switch (moodId) {
      case 1:
        mood = MoodType.FELIZ;
        break;
      case 2:
        mood = MoodType.INDIFERENTE;
        break;
      case 3:
        mood = MoodType.RAIVA;
        break;
      case 4:
        mood = MoodType.TRISTEZA;
        break;
      case 5:
        mood = MoodType.MEDO;
        break;
    }

    if (mood == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final success = await _apiService.submitMood(
        userId: widget.userId,
        mood: mood,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Humor registrado com sucesso!' : 'Ocorreu um erro.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        final avatarId = await _apiService.getMyAvatarId();

        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                DashboardScreen(avatarId: avatarId ?? 3, userId: widget.userId),
          ),
        );
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3C7F3),
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/emoteFeliz.png',
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Sereno',
                            style: TextStyle(
                              fontSize: 36,
                              color: Colors.deepPurple[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: MoodSelectionWidget(
                          onMoodConfirmed: _submitMood,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
