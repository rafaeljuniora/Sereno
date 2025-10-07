import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

enum MoodType { FELIZ, INDIFERENTE, RAIVA, TRISTEZA, MEDO }

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  static const String _baseUrl = 'http://localhost:8080/api/v1';
  static String? authToken;

  Future<int?> registerUser({
    required String email,
    required String password,
    required DateTime birthDate,
    required bool isDonaduzziStudent,
    required bool isBioparkCollaborator,
    required String hobbies,
    required String job,
    required String course,
    required String leisureTime,
    required String personalityType,
    required bool livesAlone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'birthDate': DateFormat('yyyy-MM-dd').format(birthDate),
          'isDonaduzziStudent': isDonaduzziStudent,
          'isBioparkCollaborator': isBioparkCollaborator,
          'hobbies': hobbies,
          'job': job,
          'course': course,
          'leisureTime': leisureTime,
          'personalityType': personalityType,
          'livesAlone': livesAlone,
        }),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return responseBody['id'];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        authToken = responseData['token'];
        return responseData;
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<bool> updateAvatar({
    required int userId,
    required int avatarId,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/users/$userId/avatar'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'avatarId': avatarId}),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<int?> getMyAvatarId() async {
    if (authToken == null) return null;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/me/avatar'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return int.tryParse(data['avatarId'].toString());
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> submitMood({required int userId, required MoodType mood}) async {
    final moodString = mood.toString().split('.').last;
    if (authToken == null) return false;

    final url = Uri.parse('$_baseUrl/moods');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $authToken',
    };
    final body = jsonEncode({'userId': userId, 'mood': moodString});

    try {
      final response = await http.post(url, headers: headers, body: body);
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasSubmittedMoodToday({required int userId}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/moods/today-status/$userId'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['submitted'];
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
