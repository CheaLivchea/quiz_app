// Update your existing Question model to handle the new API response structure
// Add these methods to your existing Question class:

import 'dart:convert';

class Question {
  final int id;
  final String code;
  final String questionEn;
  final String questionKh;
  final String questionZh;
  final String answerCode;
  final List<String> optionEn;
  final List<String> optionKh;
  final List<String> optionZh;
  final int categoryId;

  Question({
    required this.id,
    required this.code,
    required this.questionEn,
    required this.questionKh,
    required this.questionZh,
    required this.answerCode,
    required this.optionEn,
    required this.optionKh,
    required this.optionZh,
    required this.categoryId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert options to List<String>
    List<String> parseOptions(dynamic options) {
      if (options is List) {
        return options.map((option) => option.toString()).toList();
      }
      return [];
    }

    return Question(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      questionEn: json['questionEn'] ?? '',
      questionKh: json['questionKh'] ?? '',
      questionZh: json['questionZh'] ?? '',
      answerCode: json['answerCode'] ?? '',
      optionEn: parseOptions(json['optionEn']),
      optionKh: parseOptions(json['optionKh']),
      optionZh: parseOptions(json['optionZh']),
      categoryId: json['categoryId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'questionEn': questionEn,
      'questionKh': questionKh,
      'questionZh': questionZh,
      'answerCode': answerCode,
      'optionEn': optionEn,
      'optionKh': optionKh,
      'optionZh': optionZh,
      'categoryId': categoryId,
    };
  }

  // Helper methods for multi-language support
  String getQuestion(String locale) {
    switch (locale) {
      case 'zh':
        return questionZh.isNotEmpty ? questionZh : questionEn;
      case 'kh':
        return questionKh.isNotEmpty ? questionKh : questionEn;
      default:
        return questionEn;
    }
  }

  List<String> getOptions(String locale) {
    switch (locale) {
      case 'zh':
        return optionZh.isNotEmpty ? optionZh : optionEn;
      case 'kh':
        return optionKh.isNotEmpty ? optionKh : optionEn;
      default:
        return optionEn;
    }
  }
}

// Helper functions for JSON parsing
List<Question> questionFromJson(String str) {
  final List<dynamic> jsonList = json.decode(str);
  return jsonList.map((json) => Question.fromJson(json)).toList();
}

String questionToJson(List<Question> data) =>
    json.encode(data.map((question) => question.toJson()).toList());
