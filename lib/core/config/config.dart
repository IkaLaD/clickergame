import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static Map<String, dynamic>? _config;

  static Future<void> load() async {
    await dotenv.load(fileName: "lib/core/config/.env");
  }

  static Future<void> loadConfig() async {
    final jsonString = await rootBundle.loadString('assets/config.json');
    _config = json.decode(jsonString);
  }

  static String get baseUrl => _config?['baseUrl'];
}
