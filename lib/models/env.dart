import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get api_1 => dotenv.env['Wellnex_AI_1'] ?? '';
  static String get api_2 => dotenv.env['Wellnex_AI_2'] ?? '';
}
