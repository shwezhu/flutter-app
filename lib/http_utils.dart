import 'dart:async';
import 'dart:convert' as convert;
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/data/visitor.dart';
import 'config.dart';
import 'package:my_flutter_app/data/temperature.dart';

Future<bool> addVisitor(String url, Map<String, dynamic> json) async {
  final response = await http.post(
      Uri.parse(url),
      headers: {
        "X-Bmob-Application-Id": Config.appId,
        "X-Bmob-REST-API-Key": Config.apiKey,
        'Content-type': 'application/json; charset=UTF-8'
      },
      body: convert.jsonEncode(json)
  );

  return response.statusCode == 201;
}

Future<List<Visitor>?> getVisitors() async {
  String? responseBody = await get(Config.visitorsTable);
  if(responseBody == null) {
    return null;
  }

  Map<String, dynamic> json = convert.jsonDecode(responseBody);
  final jsonLength = json['results'].length;
  if(jsonLength == 0) {
    return null;
  }

  var visitors = <Visitor>[];
  for(int index = 0; index < jsonLength; ++index) {
    visitors.add(Visitor.fromJson(json['results'][index]));
  }

  return visitors;
}

Future<List<Temperature>?> getTemperature(String sql) async{
  String? body;
  try {
    // Use that IP address instead of localhost, because you are using emulator.
    // 'http://192.168.1.110:8080'
    body = await http.get(Uri.parse('http://172.20.10.5:8080'), headers: {'sql': sql}).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode != 200) {
        // Print(jsonDecode(response.body)["message"]);
        return null;
      }
      return response.body;
    });
  } catch(e) {
    if(e is SocketException){
      // print("Socket exception: ${e.toString()}");
      return null;
    }
    else if(e is TimeoutException){
      // print("Timeout exception: ${e.toString()}");
      return null;
    }
    else {
      // print("Unhandled exception: ${e.toString()}");
      return null;
    }
  }

  if(body == null) {
    return null;
  }

  Map<String, dynamic> json = convert.jsonDecode(body);
  var length = 0;
  try{
    // in case of json['results'] == null
    length = json['results'].length;
  }
  on NoSuchMethodError{
    return null;
  }

  if(length == 0) {
    return null;
  }

  var data = <Temperature>[];
  for(int index = 0; index < length; ++index) {
    data.add(Temperature.fromJson(json['results'][index]));
  }

  return data;
}

Future<String?> get(String url) {
  // Pass headers below
  return http.get(
      Uri.parse(url),
      headers: {
        "X-Bmob-Application-Id": Config.appId,
        "X-Bmob-REST-API-Key": Config.apiKey}).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400) {
      // Print(jsonDecode(response.body)["message"]);
      return null;
    }
    return response.body;
  });
}