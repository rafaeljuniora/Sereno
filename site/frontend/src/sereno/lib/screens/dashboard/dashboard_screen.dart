import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> mockedHistory = const [
    {'day': '26', 'month': 'JANEIRO', 'emote': 'assets/images/emoteFeliz.png'},
    {'day': '25', 'month': 'JANEIRO', 'emote': 'assets/images/emoteFeliz.png'},
    {'day': '24', 'month': 'JANEIRO', 'emote': 'assets/images/emoteIndiferente.png'},
    {'day': '23', 'month': 'JANEIRO', 'emote': 'assets/images/emoteTristeza.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3C7F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile/1.png',
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/emoteFeliz.png', height: 28),
            const SizedBox(width: 8),
            const Text(
              'Sereno',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFF3F3D56),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              Image.asset('assets/images/moedaheader.png', height: 24),
              const SizedBox(width: 4),
            ],
          ),
          const SizedBox(width: 8),

          Row(
            children: [
              Image.asset('assets/images/streakheader.png', height: 24),
              const SizedBox(width: 4),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCustomCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Frase do dia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3D56))),
                  SizedBox(height: 8),
                  Text(
                    'Aceitar suas emoções é o começo da sua serenidade.', 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCustomCard(
              child: Column(
                children: [
                  Image.asset('assets/images/termometro.png', height: 100),
                  const SizedBox(height: 8),
                  const Text('Gráfico de Emoções\nPredominantes', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3F3D56))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCustomCard(
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dia', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text('Emoção', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                  const Divider(height: 20),
                  ...mockedHistory.map((entry) => _buildHistoryRow(entry)).toList(),
                ],
              ),
            ),
             const SizedBox(height: 16),
            _buildCustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text('Novo form aberto!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3D56))),
                   const Text('nome do form', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 10),
                   Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F3D56),
                          foregroundColor: Colors.white
                        ),
                        child: const Text('Ir'),
                      ),
                   ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF6A62B1),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Image.asset('assets/images/whatsfooter.png'),
              iconSize: 32.0,
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset('assets/images/homefooter.png'),
              iconSize: 32.0,
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset('assets/images/outrosfooter.png'),
              iconSize: 32.0,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildHistoryRow(Map<String, String> entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry['month']!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(entry['day']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3D56))),
            ],
          ),
          Image.asset(entry['emote']!, height: 32),
        ],
      ),
    );
  }
}