import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/utilis/meals.dart';
import 'dart:convert';
import '../../models/meals.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import '../../providers/user_provider.dart'; // Import your user provider

class MealApp extends ConsumerStatefulWidget {
  const MealApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MealAppState();
}

class _MealAppState extends ConsumerState<MealApp> {
  List<Meals> _meals = [];
  final mealsService = MealsService();

  Future<void> _getMeals() async {
    _meals = await mealsService.getMeals();
    setState(() {});
  }

  Future<void> _generatePDF(dynamic _meals) async {
    await mealsService.generatePDF(_meals);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getMeals();
  }

  void _confirmDeleteMeal(BuildContext context, String mealId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Meal'),
          content: const Text('Are you sure you want to delete this meal?'),
          actions: [
            TextButton(
              onPressed: () async {
                await mealsService.deleteMeal(mealId).then((_) {
                  // Refresh the meal list
                  _getMeals();
                  print(mealId);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Meal deleted successfully!')),
                  );
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Error 2: $e',
                    ),
                    duration: const Duration(seconds: 30),
                  ));
                });
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAddMealDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    // final TextEditingController categoryController = TextEditingController();
    String? _selectedCategory;
    File? _image;

    Future<void> _pickImage() async {
      final ImagePickerPlatform imagePickerImplementation =
          ImagePickerPlatform.instance;
      if (imagePickerImplementation is ImagePickerAndroid) {
        imagePickerImplementation.useAndroidPhotoPicker = true;
      }
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }

      print(pickedFile);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Meal'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                // TextFormField(
                //   controller: categoryController,
                //   decoration: const InputDecoration(labelText: 'Category'),
                // ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: ['Solid Food', 'Stew', 'Drink']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Category'),
                  onChanged: (value) {
                    _selectedCategory = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category.';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final String name = nameController.text;
                final String description = descriptionController.text;
                // final String category = categoryController.text;

                await mealsService
                    .addMeal(name, description, _selectedCategory!, _image!)
                    .then((_) {
                  _getMeals(); // Refresh the meal list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Meal added successfully!')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                }).catchError((e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Meal Not added')));
                });
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditMealDialog(BuildContext context, String mealId, String mealname,
      String mealdescription, String mealcategory) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String? _selectedCategory;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Meal'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration:
                      InputDecoration(labelText: 'Current Name: $mealname'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Current Description: $mealdescription'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: ['Solid Food', 'Stew', 'Drink']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Category'),
                  onChanged: (value) {
                    _selectedCategory = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final String? name =
                    nameController.text.isNotEmpty ? nameController.text : null;
                final String? description =
                    descriptionController.text.isNotEmpty
                        ? descriptionController.text
                        : null;
                final String? category = _selectedCategory;

                final mealsService = MealsService();

                try {
                  await mealsService.updateMeal(
                      mealId, name, description, category);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Meal updated successfully!')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    String? role = authState.role;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        actions: [
          if (role == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddMealDialog,
            ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () =>
                _generatePDF(_meals), // Correctly call the function
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _meals.length,
        itemBuilder: (context, index) {
          final meal = _meals[index];
          return ListTile(
            leading: GestureDetector(
              onTap: () => _showImageModal(context, meal.image!),
              child: Image.network(
                meal.image!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(meal.name!),
            subtitle: Text('${meal.description} - Category: ${meal.category}'),
            trailing: role == 'admin'
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditMealDialog(context, meal.id!,
                            meal.name!, meal.description!, meal.category!),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDeleteMeal(context, meal.id!),
                      ),
                    ],
                  )
                : null,
          );
        },
      ),
    );
  }
}

void _showImageModal(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl), // Display the image in the modal
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(), // Close the modal
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
