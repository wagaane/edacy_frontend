import 'package:task_app/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class TaskService{
  static String authUrl = 'task/';

  static Future addTask(data) async {
    var url = Uri.parse('${ApiConfig.API_URL}${authUrl}add');

    var token = await ApiConfig.getToken();
    try{
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(data),
      );

      return jsonDecode(utf8.decode(response.bodyBytes));
    }catch(e){
      var data = {
        "status":"EXCEPTION",
        'message': 'Serveur indisponible.'
      };

      return data;
    }


  }
  static Future editTask(data, id) async {
    var url = Uri.parse('${ApiConfig.API_URL}${authUrl}edit/${id}');

    var token = await ApiConfig.getToken();
    try{
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(data),
      );

      return jsonDecode(utf8.decode(response.bodyBytes));
    }catch(e){
      var data = {
        "status":"EXCEPTION",
        'message': 'Serveur indisponible.'
      };

      return data;
    }


  }
  static Future deleteTask(id) async {
    var url = Uri.parse('${ApiConfig.API_URL}${authUrl}delete/$id');

    var token = await ApiConfig.getToken();
    try{
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );

      return jsonDecode(utf8.decode(response.bodyBytes));
    }catch(e){
      var data = {
        "status":"EXCEPTION",
        'message': 'Serveur indisponible.'
      };

      return data;
    }


  }
  static Future listTasks({page = 0, size = 10, filter = '', title = '', description = ''}) async {
    var url = Uri.parse('${ApiConfig.API_URL}${authUrl}list?page=$page&size=$size&filter=$filter&title=$title&description=$description');

    var token = await ApiConfig.getToken();
    try{
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );

      return jsonDecode(utf8.decode(response.bodyBytes));
    }catch(e){
      var data = {
        "status":"EXCEPTION",
        'message': 'Serveur indisponible.'
      };

      return data;
    }


  }

  static Future deleteListTask(List<int> taskIds) async{
    var data = taskIds.join(",");
    var url = Uri.parse('${ApiConfig.API_URL}${authUrl}delete-list-tasks/$data');

    var token = await ApiConfig.getToken();
    try{
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );

      return jsonDecode(utf8.decode(response.bodyBytes));
    }catch(e){
      var data = {
        "status":"EXCEPTION",
        'message': 'Serveur indisponible.'
      };

      return data;
    }
  }
}