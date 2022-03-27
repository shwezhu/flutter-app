import 'dart:convert' as convert;
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/data/visitor.dart';
import 'config.dart';
import 'package:my_flutter_app/data/temperature.dart';
import 'package:my_flutter_app/data/humidity.dart';


// When status code = 200 return response.body.
// Otherwise return null.
// Use that IP address instead of localhost, because you are using emulator.
// 'http://192.168.1.110:8080' instead of '192.168.1.110:8080'.
Future<String?> get(String url, {Map<String, String>? headers}) async{
  http.Response response;
  try {
    response = await http.get(Uri.parse(url), headers: headers)
        .timeout(const Duration(seconds: 3), onTimeout: () {return http.Response('Error', 408);});
  } catch(e) {
    if(e is SocketException){
      // print("Socket exception: ${e.toString()}");
      return null;
    }
    else {
      // print("Unhandled exception: ${e.toString()}");
      return null;
    }
  }

  if (response.statusCode != 200) {
    return null;
  }

  return response.body;
}

Future<List<Temperature>?> getTemperature() async{
  String? body = await get(
      'http://192.168.1.109:8080',
      headers: {'sql': 'select * from (select * from temperature order by id desc limit 20) aa order BY id'},
  );
  if(body == null) {
    return null;
  }

  Map<String, dynamic>? json = convertBodyToJson(body);
  if(json == null) {
    return null;
  }

  var data = <Temperature>[];
  final length = json['results'].length;
  for(int index = 0; index < length; ++index) {
    data.add(Temperature.fromJson(json['results'][index]));
  }

  return data;
}

Future<List<Humidity>?> getHumidity() async{
  String? body = await get(
      'http://192.168.1.109:8080',
      headers: {'sql': 'select * from (select * from humidity order by id desc limit 20) aa order BY id'},
  );
  if(body == null) {
    return null;
  }

  Map<String, dynamic>? json = convertBodyToJson(body);
  if(json == null) {
    return null;
  }

  var data = <Humidity>[];
  final length = json['results'].length;
  for(int index = 0; index < length; ++index) {
    data.add(Humidity.fromJson(json['results'][index]));
  }

  return data;
}

// Config is a user custom class that has three static String variable
// appId, apiKey and Config.visitorsTable.
// Config.visitorsTable = "https://api.bmob.cn/1/classes/visitors_information"
Future<List<Visitor>?> getVisitors() async {
  String? body = await get(
    Config.visitorsTable,
    headers: {
      "X-Bmob-Application-Id": Config.appId,
      "X-Bmob-REST-API-Key": Config.apiKey
    },
  );
  if(body == null) {
    return null;
  }

  Map<String, dynamic>? json = convertBodyToJson(body);
  if(json == null) {
    return null;
  }

  var data = <Visitor>[];
  final jsonLength = json['results'].length;
  for(int index = 0; index < jsonLength; ++index) {
    data.add(Visitor.fromJson(json['results'][index]));
  }

  return data;
}

Map<String, dynamic>? convertBodyToJson(String rawJson) {
  Map<String, dynamic> json;
  try{
    json = convert.jsonDecode(rawJson);
  } on FormatException{
    return null;
  }

  var length = 0;
  try{
    // json['results'] == null when json doesn't have key 'results'.
    // null doesn't has method: length().
    length = json['results'].length;
  } on NoSuchMethodError{
    return null;
  }

  if(length == 0) {
    return null;
  }

  return json;
}

Future<bool> addVisitor(String url, Map<String, dynamic> json) async {
  final response = await http.post(
      Uri.parse(url),
      headers: {
        "X-Bmob-Application-Id": Config.appId,
        "X-Bmob-REST-API-Key": Config.apiKey,
        'Content-type': 'application/json; charset=UTF-8'
      },
      body: convert.jsonEncode(json),
  );

  return response.statusCode == 201;
}
