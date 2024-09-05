import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/screens/meals/meal-details.dart';
import 'package:meal_app/screens/meals/meals-cart.dart';
import 'package:meal_app/utilis/meals.dart';
import '../../models/meals.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealsOrder extends ConsumerStatefulWidget {
  const MealsOrder({super.key});

  @override
  ConsumerState<MealsOrder> createState() => _MealsOrderState();
}

class _MealsOrderState extends ConsumerState<MealsOrder> {
  List<Meals> meals = [];
  final mealsService = MealsService();

  Future<void> _getMeals() async {
    meals = await mealsService.getMeals();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getMeals();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMeals = ref.watch(selectedMealsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MealCartScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return ListTile(
            leading: GestureDetector(
              onTap: () => _showImageModal(
                  context, '${meal.image}'), // Show modal on image tap
              child: Image.network(
                '${meal.image}',
                width: 50, // Adjust the width as needed
                height: 50, // Adjust the height as needed
                fit: BoxFit.cover, // Keep the aspect ratio
              ),
            ),
            title: Text('${meal.name}'),
            subtitle: Text('${meal.description} - Category: ${meal.category}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Check if the meal is already in the selected meals
                    if (selectedMeals.contains(meal)) {
                      // Show refusal message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Meal already added!')),
                      );
                    } else {
                      ref.read(selectedMealsProvider.notifier).addMeal(meal);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    // Navigate to the MealDetailsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MealDetailsScreen(mealName: '${meal.name}'),
                      ),
                    );
                  },
                ),
              ],
            ),
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
