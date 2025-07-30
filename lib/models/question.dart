// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'dart:convert';

List<Question> questionFromJson(String str) =>
    List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

String questionToJson(List<Question> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Question {
  int id;
  dynamic code;
  String questionEn;
  dynamic questionKh;
  dynamic questionZh;
  String answerCode;
  List<String> optionEn;
  dynamic optionKh;
  dynamic optionZh;
  int categoryId;

  @override
  String toString() {
    return 'Question(id: $id, questionEn: "$questionEn", answerCode: "$answerCode", optionEn: $optionEn)';
  }

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

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: int.tryParse(json["id"].toString()) ?? 0,
    code: json["code"],
    questionEn: json["questionEn"] ?? "", // fallback to empty string
    questionKh: json["questionKh"],
    questionZh: json["questionZh"],
    answerCode: json["answerCode"] ?? "",
    optionEn: json["optionEn"] != null
        ? List<String>.from(json["optionEn"].map((x) => x.toString()))
        : [],
    optionKh: json["optionKh"] != null
        ? List<String>.from(json["optionKh"].map((x) => x.toString()))
        : null,
    optionZh: json["optionZh"] != null
        ? List<String>.from(json["optionZh"].map((x) => x.toString()))
        : null,
    categoryId: int.tryParse(json["categoryId"].toString()) ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "questionEn": questionEn,
    "questionKh": questionKh,
    "questionZh": questionZh,
    "answerCode": answerCode,
    "optionEn": List<dynamic>.from(optionEn.map((x) => x)),
    "optionKh": optionKh != null
        ? List<dynamic>.from(optionKh.map((x) => x))
        : null,
    "optionZh": optionZh != null
        ? List<dynamic>.from(optionZh.map((x) => x))
        : null,
    "categoryId": categoryId,
  };
}
