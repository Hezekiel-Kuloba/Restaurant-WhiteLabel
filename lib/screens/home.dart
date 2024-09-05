import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/models/meals.dart';
import 'package:meal_app/screens/meals/meal-grid.dart';
import 'package:meal_app/screens/meals/meal-search.dart';
import 'package:meal_app/screens/meals/meals-cart.dart';
import 'package:meal_app/widgets/custom_drawer.dart';
import 'package:meal_app/widgets/custome_app_bar.dart';
import 'package:meal_app/widgets/search_bar.dart';
import 'package:meal_app/widgets/slider.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/utilis/meals.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final searchService = MealsService();
  List<Meals> _meals = []; // Declare _meals as a class-level variable

  Future<void> _searchMeals(String query) async {
    try {
      List<Meals> meals = await searchService.searchMeals(query);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(meals: meals),
        ),
      );
      setState(() {
        _meals = meals; // Update the class-level _meals variable
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedMeals = ref.watch(selectedMealsProvider);
    final cartItemCount = selectedMeals.length; // Get the cart item count

    return Scaffold(
      appBar: CustomAppBar(
        cartItemCount: cartItemCount,
        onCartPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MealCartScreen()),
          );
        },
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SearchBarWidget(
              onSearch: _searchMeals,
            ),
            const SizedBox(height: 10),
            // Use a Container with a fixed height for the GridView
            const ImageCarousel(
              imageAssets: [
                'assets/images/Bg1.jpg',
                'assets/images/Bg2.jpg',
                'assets/images/Bg3.jpg',
                'assets/images/Bg4.jpg',
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const MealsOrderGrid(),
            ),
          ],
        ),
      ),
    );
  }
}
