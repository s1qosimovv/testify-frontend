import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

import '../utils/platform_multipart_helper.dart'
    if (dart.library.html) '../utils/platform_multipart_helper_web.dart'
    if (dart.library.io) '../utils/platform_multipart_helper_mobile.dart';

class ApiService {
  Future<String> uploadFile(PlatformFile file) async {
    try {
      final uri = Uri.parse(ApiConstants.uploadFile);
      final request = http.MultipartRequest('POST', uri);
      
      final helper = getHelper();
      request.files.add(await helper.createMultipartFile(file, 'file'));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['text'];
      } else {
        throw Exception('Failed to upload file: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  Future<Map<String, dynamic>> generateQuiz(String text, {int questionCount = 10}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.generateQuiz),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'text': text,
          'num_questions': questionCount,
        }),
      ).timeout(const Duration(seconds: 120));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to generate quiz: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating quiz: $e');
    }
  }

  Future<Map<String, dynamic>> submitAnswers(String quizId, Map<int, String> answers) async {
    try {
      // Convert int keys to string keys for JSON compatibility if needed, 
      // but Backend expects map.
      // Backend expects: "answers": { "0": "A", "1": "B" }
      
      final Map<String, String> formattedAnswers = {};
      answers.forEach((key, value) {
        formattedAnswers[key.toString()] = value;
      });

      final response = await http.post(
        Uri.parse('${ApiConstants.submitAnswers}?quiz_id=$quizId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'answers': formattedAnswers}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit answers: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error submitting answers: $e');
    }
  }
  Future<String> getTelegramLink(String quizId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/get-telegram-link?quiz_id=$quizId'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['share_link'];
      } else {
        throw Exception('Failed to get Telegram link');
      }
    } catch (e) {
      throw Exception('Error getting Telegram link: $e');
    }
  }
}
