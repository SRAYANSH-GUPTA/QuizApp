import 'package:dio/dio.dart';
import 'package:quiz_app/model/quiz_model.dart';
import 'dart:developer';
class QuestionsFetch {
  final Dio dio = Dio();

  Future<Quiz> fetchQuestions() async {
    try {
      final response = await dio.get('https://api.jsonserve.com/Uw5CrX');
      log(response.data.toString());
      return Quiz.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch quiz data: $e');
    }
  }
}
