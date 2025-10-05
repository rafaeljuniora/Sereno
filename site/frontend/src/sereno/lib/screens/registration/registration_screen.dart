import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../service/api_service.dart';

enum PersonalityType { INTROVERTIDO, EXTROVERTIDO }

enum LivesAlone { SIM, NAO }

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _pageController = PageController();
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  final _apiService = ApiService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _jobController = TextEditingController();
  final _courseController = TextEditingController();
  final _leisureTimeController = TextEditingController();

  bool _isDonaduzziStudent = false;
  bool _isBioparkCollaborator = false;
  DateTime? _birthDate;
  PersonalityType? _personalityType;
  LivesAlone? _livesAlone;

  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _hobbiesController.dispose();
    _jobController.dispose();
    _courseController.dispose();
    _leisureTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _submitRegistration() async {
    if (!_formKeyStep2.currentState!.validate() ||
        _personalityType == null ||
        _livesAlone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos obrigatórios.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await _apiService.registerUser(
      email: _emailController.text,
      password: _passwordController.text,
      birthDate: _birthDate!,
      isDonaduzziStudent: _isDonaduzziStudent,
      isBioparkCollaborator: _isBioparkCollaborator,
      hobbies: _hobbiesController.text,
      job: _jobController.text,
      course: _courseController.text,
      leisureTime: _leisureTimeController.text,
      personalityType: _personalityType == PersonalityType.INTROVERTIDO
          ? 'INTROVERTIDO'
          : 'EXTROVERTIDO',
      livesAlone: _livesAlone == LivesAlone.SIM,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Cadastro realizado com sucesso!'
                : 'Falha no cadastro. Verifique os dados ou o console.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3C7F3),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [_buildStep1(), _buildStep2()],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKeyStep1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/emoteFeliz.png',
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Sereno',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.deepPurple[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            _buildTextField(
              _emailController,
              'Email',
              validator: (val) => val!.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _passwordController,
              'Senha',
              isPassword: true,
              validator: (val) =>
                  val!.length < 8 ? 'Mínimo 8 caracteres' : null,
            ),
            const SizedBox(height: 20),
            _buildSwitch(
              'É aluno da faculdade Donaduzzi?',
              _isDonaduzziStudent,
              (val) => setState(() => _isDonaduzziStudent = val),
            ),
            _buildSwitch(
              'É um colaborador do Biopark?',
              _isBioparkCollaborator,
              (val) => setState(() => _isBioparkCollaborator = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _birthDate == null
                    ? 'DATA DE NASCIMENTO'
                    : DateFormat('dd/MM/yyyy').format(_birthDate!),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (_formKeyStep1.currentState!.validate() &&
                    _birthDate != null) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preencha todos os campos para continuar.'),
                    ),
                  );
                }
              },
              child: const Text('Próximo'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {Navigator.of(context).pop();},
              child: const Text('Logar na Conta...'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKeyStep2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sereno',
              style: TextStyle(
                fontSize: 48,
                color: Colors.deepPurple[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(_hobbiesController, 'Quais os seus hobbies?'),
            const SizedBox(height: 20),
            _buildTextField(_jobController, 'Qual o seu trabalho?'),
            const SizedBox(height: 20),
            _buildTextField(_courseController, 'Qual o seu curso?'),
            const SizedBox(height: 20),
            _buildTextField(_leisureTimeController, 'Quanto tempo de lazer?'),
            const SizedBox(height: 30),
            _buildRadioGroup(
              'Você se considera:',
              _personalityType,
              PersonalityType.values,
              (val) => setState(() => _personalityType = val),
            ),
            const SizedBox(height: 20),
            _buildRadioGroup(
              'Mora sozinho?',
              _livesAlone,
              LivesAlone.values,
              (val) => setState(() => _livesAlone = val),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitRegistration,
                    child: const Text('Cadastrar'),
                  ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(color: Colors.deepPurple[800])),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.deepPurple,
    );
  }

  Widget _buildRadioGroup<T>(
    String title,
    T? groupValue,
    List<T> values,
    Function(T?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.deepPurple[800]),
        ),
        Row(
          children: values.map((value) {
            final valueText = value.toString().split('.').last.toLowerCase();
            return Expanded(
              child: RadioListTile<T>(
                title: Text(valueText),
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
