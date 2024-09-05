import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/utilis/orders.dart';
import '../../providers/user_provider.dart';

class MealCartScreen extends ConsumerStatefulWidget {
  const MealCartScreen({super.key});

  @override
  ConsumerState<MealCartScreen> createState() => _MealCartScreenState();
}

class _MealCartScreenState extends ConsumerState<MealCartScreen> {
  String specialInstructions = '';

  void _showItemAlreadyInCartMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item already in cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedMeals = ref.watch(selectedMealsProvider);
    final authState = ref.watch(authProvider);

    String? firstName = authState.firstName;
    String? lastName = authState.lastName;
    String? phoneNumber = authState.phoneNumber;

    final orderServices = OrdersService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Center(
        // Center the entire Column
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center items vertically
            children: [
              // Centered TextFormField spanning 90% of the screen with an icon
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Special Instructions',
                    hintText: 'Enter any special instructions here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: const Icon(Icons.edit), // Icon added here
                  ),
                  onChanged: (value) {
                    setState(() {
                      specialInstructions = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              // Expanded ListView spanning 90% of the screen
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                    itemCount: selectedMeals.length,
                    itemBuilder: (context, index) {
                      final meal = selectedMeals[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 5,
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
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red, // Red remove icon
                            ),
                            onPressed: () {
                              // Call the removeMeal method from the provider
                              ref
                                  .read(selectedMealsProvider.notifier)
                                  .removeMeal(meal);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Order button spanning 90% of the screen at the bottom
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedMeals.isEmpty) {
                      _showItemAlreadyInCartMessage();
                    } else {
                      orderServices.submitOrderMany(
                        firstName ?? '',
                        lastName ?? '',
                        phoneNumber ?? '',
                        specialInstructions,
                        selectedMeals,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Order Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
