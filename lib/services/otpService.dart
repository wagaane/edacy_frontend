import 'package:task_app/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class OtpService{
  static String authUrl = 'otp/';

  static Future validateOtp(otp) async {
    var url = Uri.parse('${ApiConfig.API_URL}${authUrl}validate');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(otp),
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}