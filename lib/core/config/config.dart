import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://localhost:8000';

  static Future<void> load() async {
    await dotenv.load(fileName: "lib/core/config/.env");
  }
}