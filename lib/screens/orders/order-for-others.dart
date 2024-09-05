import 'package:flutter/material.dart';
import 'package:meal_app/utilis/orders.dart';
import 'package:meal_app/utilis/users.dart';
import '../../models/meals.dart';
import 'package:meal_app/utilis/meals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class OrderOthers extends ConsumerStatefulWidget {
  const OrderOthers({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderOthersState();
}

class _OrderOthersState extends ConsumerState<OrderOthers> {
  List<Meals> _meals = [];
  final mealsService = MealsService();
  final userServices = UserServices();
  final orderServices = OrdersService();

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

  final _formKey = GlobalKey<FormState>();

  String? firstName = '';
  String? lastName = '';
  String? phoneNumber = '';
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order For Another'),
        centerTitle: true, // Center the app bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey, // Added form key for validation
          child: SingleChildScrollView(
            // Added to avoid overflow
            child: Column(
              children: [
                TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter first name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      firstName = value.trim(); // Store the input value
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter first name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter last name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      lastName = value.trim();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter last name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter phone number',
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value.trim();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter phone number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedStew,
                  decoration: const InputDecoration(
                    labelText: 'Which stew will you have',
                  ),
                  items: stews.map((stew) {
                    return DropdownMenuItem<String>(
                      value: stew,
                      child: Text(stew),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStew = value;
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
                DropdownButtonFormField<String>(
                  value: selectedSolidFood,
                  decoration: const InputDecoration(
                    labelText: 'Food to consume with chosen stew',
                  ),
                  items: solidFoods.map((food) {
                    return DropdownMenuItem<String>(
                      value: food,
                      child: Text(food),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSolidFood = value;
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
                // Alternative selections (optional)
                DropdownButtonFormField<String>(
                  value: selectedStewAlternative,
                  decoration: const InputDecoration(
                    labelText: 'Alternative stew (optional)',
                  ),
                  items: stews.map((stew) {
                    return DropdownMenuItem<String>(
                      value: stew,
                      child: Text(stew),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStewAlternative = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedSolidFoodAlternative,
                  decoration: const InputDecoration(
                    labelText: 'Alternative solid food (optional)',
                  ),
                  items: solidFoods.map((food) {
                    return DropdownMenuItem<String>(
                      value: food,
                      child: Text(food),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSolidFoodAlternative = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                // Text field for special instructions
                TextFormField(
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                    hintText: 'Why are you ordering for them?',
                  ),
                  onChanged: (value) {
                    setState(() {
                      specialInstructions = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
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

                      if (selectedMeals.isEmpty) {
                        // No meal selected, show error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select at least one meal.'),
                          ),
                        );
                        return;
                      }

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
                              content: Text('Order placed successfully!')),
                        );
                        Navigator.of(context)
                            .pop(); // Close the dialog or screen
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Order not placed: $e')),
                        );
                      }
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
