import 'package:flutter/material.dart';

class Utils {
  static void handleException(response) {
    print(response.statusCode);
  }

  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;
}
