// To parse this JSON data, do
//
//     final wordWarningResponseModel = wordWarningResponseModelFromJson(jsonString);

import 'dart:convert';

WordWarningResponseModel wordWarningResponseModelFromJson(String str) =>
    WordWarningResponseModel.fromJson(json.decode(str));

String wordWarningResponseModelToJson(WordWarningResponseModel data) =>
    json.encode(data.toJson());

class WordWarningResponseModel {
  String clean;
  String language;
  List<String> profanities;

  WordWarningResponseModel({
    required this.clean,
    required this.language,
    required this.profanities,
  });

  factory WordWarningResponseModel.fromJson(Map<String, dynamic> json) =>
      WordWarningResponseModel(
        clean: json["clean"],
        language: json["language"],
        profanities: List<String>.from(json["profanities"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "clean": clean,
        "language": language,
        "profanities": List<dynamic>.from(profanities.map((x) => x)),
      };
}
