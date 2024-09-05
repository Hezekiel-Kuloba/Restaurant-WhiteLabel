import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/models/meals.dart';

// StateNotifier to manage the list of selected meals
class SelectedMealsNotifier extends StateNotifier<List<Meals>> {
  SelectedMealsNotifier() : super([]);

  void addMeal(Meals meal) {
    state = [...state, meal];
  }

  void removeMeal(Meals meal) {
    state = state.where((m) => m.id != meal.id).toList();
  }

  void clearMeals() {
    state = [];
  }
}

// Create a provider for the StateNotifier
final selectedMealsProvider =
    StateNotifierProvider<SelectedMealsNotifier, List<Meals>>(
        (ref) => SelectedMealsNotifier());
