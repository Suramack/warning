import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:warning/core/model/image_warning_response_model.dart';
import 'package:warning/core/model/word_check_response_model.dart';
import 'package:warning/utils/utils.dart';

class WarningService {
  static Future<ImageWarningResponseModel> checkImageWarning(
      String imagePath) async {
    var url =
        'https://nsfw-images-detection-and-classification.p.rapidapi.com/adult-content-file';
    var apiKey = 'f3ffef3dc4msh6f18e90cb23691ap1853b1jsn2c8cf372b608';
    var host = 'nsfw-images-detection-and-classification.p.rapidapi.com';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    Uint8List imageFile = File(imagePath).readAsBytesSync();

    var pic =
        http.MultipartFile.fromBytes('image', imageFile, filename: 'image');

    request.files.add(pic);

    request.headers.addAll({
      "X-RapidAPI-Key": apiKey,
      "X-RapidAPI-Host": host,
    });

    var response = await request.send();

    var responseData = await response.stream.toBytes();

    var responseJson = String.fromCharCodes(responseData);

    if (response.statusCode == 200) {
      return imageWarningResponseModelFromJson(responseJson);
    } else {
      Utils.handleException(response);
      throw response;
    }
  }

  static Future<WordWarningResponseModel> wordCheck(String sentance) async {
    var url =
        'https://profanity-cleaner-bad-word-filter.p.rapidapi.com/profanity';
    var apiKey = 'f3ffef3dc4msh6f18e90cb23691ap1853b1jsn2c8cf372b608';
    var host = 'profanity-cleaner-bad-word-filter.p.rapidapi.com';
    var k = {
      "text": sentance,
      "maskCharacter": "x",
      "language": "en",
    };
    var response = await http.post(
      Uri.parse(url),
      body: json.encode(k),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        "X-RapidAPI-Key": apiKey,
        "X-RapidAPI-Host": host,
      },
    );
    if (response.statusCode == 200) {
      return wordWarningResponseModelFromJson(response.body);
    } else {
      Utils.handleException(response);
      throw response;
    }
  }
}
