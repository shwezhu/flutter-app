import 'dart:convert' as convert;
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/data/visitor.dart';
import 'config.dart';

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