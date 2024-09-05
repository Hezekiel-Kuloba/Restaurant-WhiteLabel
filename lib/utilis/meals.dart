// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:meal_app/models/meals.dart';
// import 'package:meal_app/models/order.dart';
// import 'package:path/path.dart' as p;
// import 'dart:io';
// import 'package:image_picker_android/image_picker_android.dart';
// import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/foundation.dart'; // For kIsWeb
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_share/flutter_share.dart';

// class MealsService {
//   String url = 'http://192.168.100.9:3000/';
//   Future<void> requestPermission() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }
//   }

//   Future<void> openFile() async {
//     final directory = await getExternalStorageDirectory();
//     final filePath = '${directory!.path}/Meal.pdf';

//     // Share the file
//     await shareFile(filePath);

//     // Or open the file if needed
//     // final result = await OpenFile.open(filePath);
//     // if (result.type != ResultType.done) {
//     //   print('Failed to open file');
//     // }
//   }

//   Future<void> shareFile(String filePath) async {
//     await FlutterShare.shareFile(
//       title: 'Share PDF',
//       filePath: filePath,
//       fileType: 'application/pdf',
//     );
//   }

//   Future<void> generatePDF(List<Meals> meals) async {
//     await requestPermission(); // Ensure permission is granted

//     final List<Map<String, String>> mealsData = meals.map((meal) {
//       return {
//         'mealName': meal.name ?? '',
//         'mealImage': meal.image ?? '',
//       };
//     }).toList();

//     final response = await http.post(
//       Uri.parse('${url}generate-pdf'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'meals': mealsData}),
//     );

//     if (response.statusCode == 200) {
//       try {
//         final directory = await getApplicationDocumentsDirectory();
//         final filePath = '${directory.path}/Meal.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         print('PDF saved at $filePath');

//         // Open or share the PDF after saving
//         await openFile();
//       } catch (e) {
//         print('Error saving PDF: $e');
//       }
//     } else {
//       print('Failed to generate PDF: ${response.reasonPhrase}');
//     }
//   }

//   Future<List<Meals>> getMeals() async {
//     final response = await http.post(Uri.parse('${url}api/v1/meals/get-all'));
//     List<Meals> meals = [];

//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body);
//       final mealsData = jsonData['data']['data'];
//       if (mealsData != null && mealsData is List) {
//         meals = mealsData.map((json) {
//           return Meals.fromJson(json);
//         }).toList();
//       } else {
//         // Handle the case when 'data' is null or not a list
//         print('Error: Invalid data format');
//       }
//     } else {
//       throw Exception('Failed to load meals');
//     }
//     return meals;
//   }

//   Future<List<Meals>> searchMeals(String query) async {
//     final response = await http.post(
//       Uri.parse('${url}api/v1/meal-search'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'name': query}),
//     );

//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body);
//       List<Meals> meals = [];
//       if (jsonData is List) {
//         meals = jsonData.map((json) => Meals.fromJson(json)).toList();
//       }
//       return meals;
//     } else {
//       throw Exception('Failed to load search results');
//     }
//   }

//   Future<Meals> fetchMealDetails(String mealName) async {
//     final response = await http.post(
//       Uri.parse('${url}api/v1/meal-details'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'mealName': mealName,
//       }),
//     );

//     if (response.statusCode == 200) {
//       return Meals.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load meal details');
//     }
//   }

//   // Delete a meal
//   Future<void> deleteMeal(String id) async {
//     final response = await http.post(
//       Uri.parse('${url}api/v1/meals/delete'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'id': id,
//       }),
//     );

//     if (response.statusCode != 204) {
//       throw Exception('Failed to delete meal');
//     }
//   }

//   Future<void> addMeal(
//       String name, String description, String category, File image) async {
//     final ImagePickerPlatform imagePickerImplementation =
//         ImagePickerPlatform.instance;
//     if (imagePickerImplementation is ImagePickerAndroid) {
//       imagePickerImplementation.useAndroidPhotoPicker = true;
//     }

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('${url}api/v1/meals/add-meal'),
//     );

//     request.fields['name'] = name;
//     request.fields['description'] = description;
//     request.fields['category'] = category;
//     request.files.add(await http.MultipartFile.fromPath(
//       'imageFile',
//       image.path,
//       filename: p.basename(image.path),
//     ));

//     var response = await request.send();

//     if (response.statusCode != 201) {
//       throw Exception('Failed to add meal: ${response.reasonPhrase}');
//     }
//   }

//   // Future<void> updateMeal(
//   //     String id, String name, String description, String category) async {
//   //   final response = await http.post(
//   //     Uri.parse('${url}api/v1/meals/update'),
//   //     headers: <String, String>{
//   //       'Content-Type': 'application/json; charset=UTF-8',
//   //     },
//   //     body: jsonEncode(<String, String>{
//   //       'id': id,
//   //       'name': name,
//   //       'description': description,
//   //       'category': category,
//   //     }),
//   //   );

//   //   if (response.statusCode != 200) {
//   //     throw Exception('Failed to update meal: ${response.body}');
//   //   }
//   // }

//   Future<void> updateMeal(
//       String id, String? name, String? description, String? category) async {
//     final Map<String, dynamic> updateData = {};

//     updateData['id'] = id;
//     if (name != null) updateData['name'] = name;
//     if (description != null) updateData['description'] = description;
//     if (category != null) updateData['category'] = category;

//     final response = await http.post(
//       Uri.parse(
//           '${url}api/v1/meals/update'), // Update the endpoint as necessary
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(updateData),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to update meal: ${response.body}');
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart'; // Updated import

import 'package:meal_app/models/meals.dart';

class MealsService {
  String url = 'http://192.168.100.154:3000/';

  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> openFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/Meal.pdf';

    // Ensure the file exists
    if (await File(filePath).exists()) {
      // Share the file
      await shareFile(filePath);
    } else {
      print('File not found at $filePath');
    }
  }

  Future<void> shareFile(String filePath) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath, mimeType: 'application/pdf')],
        text: 'Here is your PDF!',
      );
    } catch (e) {
      print('Error sharing file: $e');
    }
  }

  Future<void> generatePDF(List<Meals> meals) async {
    await requestPermission(); // Ensure permission is granted

    final List<Map<String, String>> mealsData = meals.map((meal) {
      return {
        'mealName': meal.name ?? '',
        'mealImage': meal.image ?? '',
        'mealdescription': meal.description ?? '',
      };
    }).toList();

    final response = await http.post(
      Uri.parse('${url}generate-pdf'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'meals': mealsData}),
    );

    if (response.statusCode == 200) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/Meal.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('PDF saved at $filePath');

        // Open or share the PDF after saving
        await openFile();
      } catch (e) {
        print('Error saving PDF: $e');
      }
    } else {
      print('Failed to generate PDF: ${response.reasonPhrase}');
    }
  }

  Future<List<Meals>> getMeals() async {
    final response = await http.post(Uri.parse('${url}api/v1/meals/get-all'));
    List<Meals> meals = [];

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final mealsData = jsonData['data']['data'];
      if (mealsData != null && mealsData is List) {
        meals = mealsData.map((json) {
          return Meals.fromJson(json);
        }).toList();
      } else {
        // Handle the case when 'data' is null or not a list
        print('Error: Invalid data format');
      }
    } else {
      throw Exception('Failed to load meals');
    }
    return meals;
  }

  Future<List<Meals>> searchMeals(String query) async {
    final response = await http.post(
      Uri.parse('${url}api/v1/meal-search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': query}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Meals> meals = [];
      if (jsonData is List) {
        meals = jsonData.map((json) => Meals.fromJson(json)).toList();
      }
      return meals;
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<Meals> fetchMealDetails(String mealName) async {
    final response = await http.post(
      Uri.parse('${url}api/v1/meal-details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mealName': mealName,
      }),
    );

    if (response.statusCode == 200) {
      return Meals.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  // Delete a meal
  Future<void> deleteMeal(String id) async {
    final response = await http.post(
      Uri.parse('${url}api/v1/meals/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete meal');
    }
  }

  Future<void> addMeal(
      String name, String description, String category, File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${url}api/v1/meals/add-meal'),
    );

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['category'] = category;
    request.files.add(await http.MultipartFile.fromPath(
      'imageFile',
      image.path,
      filename: p.basename(image.path),
    ));

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to add meal: ${response.reasonPhrase}');
    }
  }

  Future<void> updateMeal(
      String id, String? name, String? description, String? category) async {
    final Map<String, dynamic> updateData = {};

    updateData['id'] = id;
    if (name != null) updateData['name'] = name;
    if (description != null) updateData['description'] = description;
    if (category != null) updateData['category'] = category;

    final response = await http.post(
      Uri.parse('${url}api/v1/meals/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update meal: ${response.body}');
    }
  }
}
