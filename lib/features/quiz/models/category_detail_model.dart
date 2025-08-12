import 'dart:convert';
import '../../../core/constants/models/question.dart';

// Model for the category detail response
class CategoryDetail {
  final String iconUrl;
  final int id;
  final String nameEn;
  final String nameZh;
  final String nameKh;
  final List<Question> questions;

  CategoryDetail({
    required this.iconUrl,
    required this.id,
    required this.nameEn,
    required this.nameZh,
    required this.nameKh,
    required this.questions,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      iconUrl: json['iconUrl'] ?? '',
      id: json['id'] ?? 0,
      nameEn: json['nameEn'] ?? '',
      nameZh: json['nameZh'] ?? '',
      nameKh: json['nameKh'] ?? '',
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((questionJson) => Question.fromJson(questionJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iconUrl': iconUrl,
      'id': id,
      'nameEn': nameEn,
      'nameZh': nameZh,
      'nameKh': nameKh,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  // Helper method to get category name based on locale
  String getName(String locale) {
    switch (locale) {
      case 'zh':
        return nameZh.isNotEmpty ? nameZh : nameEn;
      case 'kh':
        return nameKh.isNotEmpty ? nameKh : nameEn;
      default:
        return nameEn;
    }
  }
}

// Helper functions for JSON parsing
CategoryDetail categoryDetailFromJson(String str) =>
    CategoryDetail.fromJson(json.decode(str));

String categoryDetailToJson(CategoryDetail data) => json.encode(data.toJson());
