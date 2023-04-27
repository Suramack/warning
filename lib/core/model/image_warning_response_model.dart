// To parse this JSON data, do
//
//     final imageWarningResponseModel = imageWarningResponseModelFromJson(jsonString);

import 'dart:convert';

ImageWarningResponseModel imageWarningResponseModelFromJson(String str) =>
    ImageWarningResponseModel.fromJson(json.decode(str));

String imageWarningResponseModelToJson(ImageWarningResponseModel data) =>
    json.encode(data.toJson());

class ImageWarningResponseModel {
  bool unsafe;
  List<Object> objects;

  ImageWarningResponseModel({
    required this.unsafe,
    required this.objects,
  });

  factory ImageWarningResponseModel.fromJson(Map<String, dynamic> json) =>
      ImageWarningResponseModel(
        unsafe: json["unsafe"],
        objects:
            List<Object>.from(json["objects"].map((x) => Object.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "unsafe": unsafe,
        "objects": List<dynamic>.from(objects.map((x) => x.toJson())),
      };
}

class Object {
  List<int> box;
  double score;
  String label;

  Object({
    required this.box,
    required this.score,
    required this.label,
  });

  factory Object.fromJson(Map<String, dynamic> json) => Object(
        box: List<int>.from(json["box"].map((x) => x)),
        score: json["score"]?.toDouble(),
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "box": List<dynamic>.from(box.map((x) => x)),
        "score": score,
        "label": label,
      };
}
