import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quiz_app/model/quiz_model.dart';
import 'package:quiz_app/utils/error_handler.dart';

import 'dart:convert';
import 'dart:async';

class QuestionsFetch {
 

  Future<Quiz> fetchQuestions() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.jsonserve.com/Uw5CrX'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Quiz.fromJson(jsonDecode(response.body));
      } else {
        throw ServerError(
          'Failed to load questions',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw NetworkError('No internet connection');
    } on TimeoutException {
      throw NetworkError('Connection timed out');
    } catch (e) {
      throw ServerError('Failed to fetch questions: $e');
    }
  }
}
