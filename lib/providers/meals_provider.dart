import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dummy_data.dart';

final mealsProvider = Provider((ref) {
  return dummyMeals;
});

class Meal {
  final String name;
  final String description;
  final String image;
  final String category;

  Meal({
    required this.name,
    required this.description,
    required this.image,
    required this.category,
  });
}
