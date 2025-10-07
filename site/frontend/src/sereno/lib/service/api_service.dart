import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

enum MoodType { FELIZ, INDIFERENTE, RAIVA, TRISTEZA, MEDO }

class ApiService {
  static const String _baseUrl = 'http://localhost:8080/api/v1';

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
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
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
    } else {
      return null;
    }
    } catch (e) {
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
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<bool> updateAvatar({
    required int userId,
    required String avatarId,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/users/$userId/avatar'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'avatarId': avatarId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitMood({required int userId, required MoodType mood}) async {
  final String moodString = mood.toString().split('.').last;
  
  final url = Uri.parse('$_baseUrl/moods');
  final body = jsonEncode(<String, dynamic>{
    'userId': userId,
    'moodType': moodString,
  });

  try {
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: body,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }

  } catch (e) {
    return false;
  }
}

  Future<bool> hasSubmittedMoodToday({required int userId}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/moods/today-status/$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['submitted'];
      }
      return false;
    } catch (e) { return false; }
  }
}