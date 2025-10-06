import 'package:flutter/material.dart';
// Importa suas telas existentes/novas
import 'package:sereno/screens/registration/registration_screen.dart';
import '../tests_screens/tela_de_teste_widgets.dart'; // Tela do Gráfico (caminho relativo)
import 'package:sereno/screens/tests_screens/seletor_diario_emocao.dart'; // Importa a nova tela de seleção de humor

class MainMenuNavigator extends StatelessWidget {
  const MainMenuNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu de Navegação (Dev/Teste)'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Escolha a funcionalidade para testar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),

            // Botão para a Tela de Registro (seu home original)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationScreen(),
                  ),
                );
              },
              child: const Text('Ir para o Registro/Login'),
            ),
            const SizedBox(height: 20),

            // Botão para o Teste do Componente de Emoções (Gráfico)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmotionChartTestScreen(),
                  ),
                );
              },
              child: const Text('Testar Gráfico de Emoções'),
            ),
            const SizedBox(height: 20),

            // NOVO BOTÃO: Para a tela de seleção de humor diário
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Navega para a tela que contém o MoodSelectionWidget
                    builder: (context) => const DailyMoodSelectorScreen(),
                  ),
                );
              },
              child: const Text(
                'Testar Seleção de Humor Diário (Novo Componente)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
