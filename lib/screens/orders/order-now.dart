import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meal_app/models/user.dart';
import 'package:meal_app/utilis/orders.dart';
import 'package:meal_app/utilis/users.dart';
import 'dart:convert';
import '../../models/meals.dart';
import '../../models/order.dart';
import 'package:meal_app/utilis/meals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class OrderNow extends ConsumerStatefulWidget {
  const OrderNow({super.key});

  @override
  ConsumerState createState() => _OrderNowState();
}

class _OrderNowState extends ConsumerState<OrderNow> {
  List<Meals> _meals = [];
  final mealsService = MealsService();
  final userServices = UserServices();
  final orderServices = OrdersService();

  String? selectedStew;
  String? selectedSolidFood;
  String? selectedStewAlternative;
  String? selectedSolidFoodAlternative;
  String specialInstructions = '';
  List<String> stews = [];
  List<String> solidFoods = [];

  @override
  void initState() {
    super.initState();
    _getMeals();
  }

  Future<void> _getMeals() async {
    _meals = await mealsService.getMeals();
    setState(() {
      stews = _meals
          .where((meal) => meal.category == 'Stew')
          .map((meal) => meal.name as String)
          .toList();
      solidFoods = _meals
          .where((meal) => meal.category == 'Solid Food')
          .map((meal) => meal.name as String)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    String? firstName = authState.firstName;
    String? lastName = authState.lastName;
    String? phoneNumber = authState.phoneNumber;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Now'),
        centerTitle: true, // Center the app bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          // Wrap content in a scrollable view
          child: Form(
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: selectedStew,
                  decoration: const InputDecoration(
                    labelText: 'Which stew will you have?',
                  ),
                  items: stews.map((stew) {
                    return DropdownMenuItem(
                      value: stew,
                      child: Text(stew),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStew = value as String?;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a stew.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField(
                  value: selectedSolidFood,
                  decoration: const InputDecoration(
                    labelText: 'Food to consume with chosen stew?',
                  ),
                  items: solidFoods.map((food) {
                    return DropdownMenuItem(
                      value: food,
                      child: Text(food),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSolidFood = value as String?;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a solid food.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField(
                  value: selectedStewAlternative,
                  decoration: const InputDecoration(
                    labelText: 'Which alternative stew will you have?',
                  ),
                  items: stews.map((stew) {
                    return DropdownMenuItem(
                      value: stew,
                      child: Text(stew),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStewAlternative = value as String?;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an alternative stew.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField(
                  value: selectedSolidFoodAlternative,
                  decoration: const InputDecoration(
                    labelText: 'Food to consume with alternative stew?',
                  ),
                  items: solidFoods.map((food) {
                    return DropdownMenuItem(
                      value: food,
                      child: Text(food),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSolidFoodAlternative = value as String?;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a solid food.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Special Instructions',
                    hintText: 'Enter any special instructions here',
                  ),
                  onChanged: (value) {
                    setState(() {
                      specialInstructions = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    // Gather selected meals into a list
                    List<Meals> selectedMeals = [];
                    if (selectedStew != null) {
                      selectedMeals.add(Meals(
                          name: selectedStew!, description: 'Stew selected'));
                    }
                    if (selectedSolidFood != null) {
                      selectedMeals.add(Meals(
                          name: selectedSolidFood!,
                          description: 'Solid food selected'));
                    }
                    if (selectedStewAlternative != null) {
                      selectedMeals.add(Meals(
                          name: selectedStewAlternative!,
                          description: 'Alternative stew selected'));
                    }
                    if (selectedSolidFoodAlternative != null) {
                      selectedMeals.add(Meals(
                          name: selectedSolidFoodAlternative!,
                          description: 'Alternative solid food selected'));
                    }

                    // Call the submitOrderMany function
                    try {
                      await orderServices.submitOrderMany(
                        firstName!,
                        lastName!,
                        phoneNumber!,
                        specialInstructions,
                        selectedMeals,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Order Placed successfully!')),
                      );
                      Navigator.of(context).pop(); // Close the dialog
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$e Order not placed')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
