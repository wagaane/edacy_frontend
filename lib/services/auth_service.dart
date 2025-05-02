import 'package:task_app/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:task_app/models/enums/ResponseStatus.dart';

class AuthService{
  static String authUrl = 'auth/';


  static Future login(data) async {
    try{
      var url = Uri.parse('${ApiConfig.API_URL}${authUrl}login');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      return jsonDecode(utf8.decode(response.bodyBytes));
    }catch(e){
      var response = {
        "status": ResponseStatus.EXCEPTION.name,
        "message": "Une erreur s'est produite lors de la connexion."
      };
      return response;
    }


  }


  static Future register(registerRequest) async {
    var url = Uri.parse('${ApiConfig.API_URL}${authUrl}register');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(registerRequest),
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

}