import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/models/meals.dart';
import 'package:meal_app/providers/meal_provider.dart';

class SearchResultsScreen extends ConsumerWidget {
  final List<Meals> meals;

  const SearchResultsScreen({super.key, required this.meals});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  '${meal.image}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                '${meal.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${meal.description} - Category: ${meal.category}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Add the meal to the cart
                  ref.read(selectedMealsProvider.notifier).addMeal(meal);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${meal.name} added to cart!'),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
