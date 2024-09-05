import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/rule.dart';

class RuleServices {
  String url = 'http://192.168.100.154:3000';

  Future<List<Rules>> getRules() async {
    final response = await http.post(Uri.parse('$url/api/v1/kitchen/get-all'));
    List<Rules> rules = [];

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      final ruleData = jsonData['data']['data'];
      if (ruleData != null && ruleData is List) {
        rules = ruleData.map((json) {
          return Rules.fromJson(json);
        }).toList();
        print(rules);
      } else {
        // Handle the case when 'data' is null or not a list
        print('Error: Invalid data format');
      }
    } else {
      throw Exception('Failed to load rule ${response.body}');
    }
    return rules;
  }

  Future<void> deleterule(String ruleId, String token) async {
    final response = await http.post(
      Uri.parse('$url/api/v1/kitchen/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'id': ruleId,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete rule: ${response.body}');
    }
  }

  Future<Rules> updaterule(String ruleId, String rules) async {
    final response = await http.post(
      Uri.parse('$url/api/v1/kitchen/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id': ruleId, 'rule': rules}),
    );

    if (response.statusCode == 200) {
      return Rules.fromJson(json.decode(response.body));
    } else {
      print(response.body);

      throw Exception('Failed to update rule in ${response.body}');
    }
  }

  Future<Rules> addRules(String rule) async {
    final response = await http.post(
      Uri.parse(
          '$url/api/v1/kitchen/add'), // Update to your registration endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'rule': rule,
      }),
    );

    if (response.statusCode == 201) {
      return Rules.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add rule: ${response.body}');
    }
  }
}
