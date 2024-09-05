import 'dart:convert';
import '../../models/meals.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/models/order.dart';
import 'package:path/path.dart' as p;
import '../../models/order.dart'; // Ensure you have a order model
import 'dart:io';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class OrdersService {
  String url = 'http://192.168.100.154:3000/';
  Future<List<Orders>> getOrders() async {
    final response = await http.post(Uri.parse('${url}api/v1/orders/get-all'));
    List<Orders> orders = [];

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final orderData = jsonData['data']['data'];
      if (orderData != null && orderData is List) {
        orders = orderData.map((json) {
          return Orders.fromJson(json);
        }).toList();
      } else {
        // Handle the case when 'data' is null or not a list
        print('Error: Invalid data format');
      }
    } else {
      throw Exception('Failed to load Orders');
    }
    return orders;
  }

  Future<void> submitOrderMany(
    String firstName,
    String lastName,
    String phoneNumber,
    String specialInstructions,
    List<Meals> selectedMeals,
  ) async {
    final orderData = selectedMeals
        .map((meal) => {
              'Stew_name': meal.name,
              'solidFood_name': meal.description,
            })
        .toList();

    final response = await http.post(
      Uri.parse('${url}api/v1/order-array'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'specific_instructions': specialInstructions,
        'orders': orderData,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Order not placed: ${response.body}');
    }
  }

  Future<void> submitOrder(
      String firstName,
      String lastName,
      String phoneNumber,
      String stewname,
      String solidfoodname,
      String selectedSolidFoodAlternative,
      String selectedStewAlternative,
      String specialInstructions) async {
    final response = await http.post(
      Uri.parse('${url}api/v1/orders/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'Stew_name': stewname,
        'solidFood_name': solidfoodname,
        'alternative_solidFood_name': selectedSolidFoodAlternative,
        'alternative_stew_name': selectedStewAlternative,
        'specific_instructions': specialInstructions,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Order not placed: ${response.body}');
    }
    if (response.statusCode == 200) {
      print('Respone is ${response.body}');
    }
  }

  Future<void> deleteOrder(String id) async {
    final response = await http.post(
      Uri.parse('${url}api/v1/orders/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
      }),
    );

    if (response.statusCode != 204) {
      // throw Exception('Failed to delete meal 2: ${response.body}');
      throw Exception('Failed to delete order');
    }
  }

  Future<void> updateOrder(
    String id,
    String firstName,
    String stewname,
    String solidfoodname,
  ) async {
    final response = await http.post(
      Uri.parse('$url/api/v1/orders/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'firstName': firstName,
        'Stew_name': stewname,
        'solidFood_name': solidfoodname,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update meal: ${response.body}');
    }
  }
}
