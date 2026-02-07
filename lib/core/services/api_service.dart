import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class ApiService {
  Future<String> uploadFile(PlatformFile file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.uploadFile));
      
      if (kIsWeb) {
        // Web: use bytes
        if (file.bytes == null) {
           // On web, bytes should be available if picked correctly. 
           // Note: file_picker might need 'withData: true' but it's default usually?
           // Actually, pickFiles loads bytes by default on web.
           throw Exception("File bytes are null on Web");
        }
        request.files.add(http.MultipartFile.fromBytes(
          'file', 
          file.bytes!, 
          filename: file.name
        ));
      } else {
        // Mobile: use path
        if (file.path == null) {
          throw Exception("File path is null on Mobile");
        }
        request.files.add(await http.MultipartFile.fromPath('file', file.path!));
      }

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
      ).timeout(const Duration(seconds: 30));

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
