import 'package:flutter_dotenv/flutter_dotenv.dart';
// patron adaptador para crear un wrapper  de dotenv
class Environment {
  
  static initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }

  static String apiUrl =
      dotenv.env['API_URL'] ?? 'Variable no configurada API_URL';
}
