import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:8080/api/v1';

  Future<bool> registerUser({
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginUser({
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}