import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

import '../../models/register.dart';

import '../../models/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/utilis/users.dart';
import 'dart:convert';
import '../../models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class UserServices {
  String url = 'http://192.168.100.154:3000';

  Future<User> getUserById(String id, String token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$url/api/v1/users/get-by-id'),
      headers: headers,
      body: jsonEncode(<String, String>{
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      // Navigate through the nested data structure
      final userData = responseBody['data']['data'];

      // Convert the nested user data to a User object
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to fetch user: ${response.body}');
    }
  }

  Future<List<User>> getUsers() async {
    final response = await http.post(Uri.parse('$url/api/v1/users/get-all'));
    List<User> users = [];

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      final userData = jsonData['data']['data'];
      if (userData != null && userData is List) {
        users = userData.map((json) {
          return User.fromJson(json);
        }).toList();
        print(users);
      } else {
        // Handle the case when 'data' is null or not a list
        print('Error: Invalid data format');
      }
    } else {
      throw Exception('Failed to load User ${response.body}');
    }
    return users;
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('${url}/api/v1/users/logout'),
    );
    if (response.statusCode == 200) {
      print("user logged out succesfull");
    } else {
      throw Exception('Failed to logout user: ${response.body}');
    }
  }

  Future<RegisterResponse> register(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String password,
      String passwordConfirm) async {
    final response = await http.post(
      Uri.parse(
          '$url/api/v1/users/signup'), // Update to your registration endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'passwordConfirm': passwordConfirm,
      }),
    );

    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$url/api/v1/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to log in ${response.body}');
    }
  }

  // Delete a meal
  Future<void> deleteUser(String userId, String token) async {
    final response = await http.post(
      Uri.parse('$url/api/v1/users/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'id': userId,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user: ${response.body}');
    }
  }

  Future<LoginResponse> updateUser(String id, String firstName, String lastName,
      String email, String phoneNumber, String token) async {
    final response = await http.post(
      Uri.parse('$url/api/v1/users/update-me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      print(response.body);

      throw Exception('Failed to log in ${response.body}');
    }
  }
}
