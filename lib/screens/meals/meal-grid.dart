import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/screens/meals/meal-details.dart';
import 'package:meal_app/utilis/meals.dart';
import '../../models/meals.dart';

class MealsOrderGrid extends ConsumerStatefulWidget {
  const MealsOrderGrid({super.key});

  @override
  ConsumerState<MealsOrderGrid> createState() => _MealsOrderGridState();
}

class _MealsOrderGridState extends ConsumerState<MealsOrderGrid> {
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          childAspectRatio: 0.75, // Aspect ratio of each grid item
        ),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the MealDetailsScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MealDetailsScreen(mealName: '${meal.name}'),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Image with fixed percentage width and padding
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      '${meal.image}',
                      width: screenWidth * 0.4, // 40% of screen width
                      height: screenWidth *
                          0.4, // Ensure the height matches the width
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${meal.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            final selectedMeal = meals[index];
                            ref
                                .read(selectedMealsProvider.notifier)
                                .addMeal(selectedMeal);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
