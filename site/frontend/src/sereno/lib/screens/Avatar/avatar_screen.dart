import 'package:flutter/material.dart';
import 'package:sereno/screens/dashboard/dashboard_screen.dart';
import 'package:sereno/screens/mood/mood_screen.dart';
import '../../service/api_service.dart';

class AvatarScreen extends StatefulWidget {
  final int userId;

  const AvatarScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AvatarScreenState createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  final _apiService = ApiService();
  int _currentAvatarIndex = 1;
  final int _totalAvatars = 23;
  bool _isLoading = false;

  void _previousAvatar() {
    setState(() {
      _currentAvatarIndex = (_currentAvatarIndex > 1)
          ? _currentAvatarIndex - 1
          : _totalAvatars;
    });
  }

  void _nextAvatar() {
    setState(() {
      _currentAvatarIndex = (_currentAvatarIndex < _totalAvatars)
          ? _currentAvatarIndex + 1
          : 1;
    });
  }

  void _saveAvatar() async {
    setState(() => _isLoading = true);

    final success = await _apiService.updateAvatar(
      userId: widget.userId,
      avatarId: _currentAvatarIndex,
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar o avatar. Tente mais tarde.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final hasMood = await _apiService.hasSubmittedMoodToday(
      userId: widget.userId,
    );

    if (hasMood) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            avatarId: _currentAvatarIndex,
            userId: widget.userId,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MoodScreen(userId: widget.userId),
        ),
        (Route<dynamic> route) => false,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avatar salvo com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3C7F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/emoteFeliz.png', height: 40),
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
              Column(
                children: [
                  Text(
                    'Escolha seu avatar',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.deepPurple[800],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: _previousAvatar,
                        color: Colors.deepPurple[800],
                        iconSize: 40,
                      ),
                      ClipOval(
                        child: Image.asset(
                          'assets/images/profile/$_currentAvatarIndex.png',
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: _nextAvatar,
                        color: Colors.deepPurple[800],
                        iconSize: 40,
                      ),
                    ],
                  ),
                ],
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveAvatar,
                      child: const Text('Salvar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
