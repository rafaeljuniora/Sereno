import 'package:flutter/material.dart';
// Importa o componente modularizado MoodSelectionWidget
import '../../components/mood_selection_widget.dart';

class DailyMoodSelectorScreen extends StatelessWidget {
  const DailyMoodSelectorScreen({super.key});

  /// Função que lida com o ID de humor recebido do componente.
  void handleMoodConfirmation(BuildContext context, int moodId) {
    // --- LÓGICA DE SALVAMENTO ---
    // Aqui é onde você fará a chamada ao banco de dados (Firebase/API)
    // usando o 'moodId' (o ID da emoção selecionada).

    print(
      "--- DADO RECEBIDO PARA BACKEND/ARMAZENAMENTO: ID da EMOÇÃO: $moodId ---",
    );

    // Feedback visual na tela (apenas para teste)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Humor do dia (ID: $moodId) registrado com sucesso!"),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA), // Fundo Lilás Claro
      appBar: AppBar(
        title: const Text('Registro de Humor Diário'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40),
          // Usa o seu componente modularizado MoodSelectionWidget aqui
          child: MoodSelectionWidget(
            // Passa a função de tratamento de dados (handleMoodConfirmation) como callback
            onMoodConfirmed: (id) => handleMoodConfirmation(context, id),
          ),
        ),
      ),
    );
  }
}
