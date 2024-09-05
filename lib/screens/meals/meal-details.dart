import 'package:flutter/material.dart';
import 'package:meal_app/models/meals.dart';
import 'package:meal_app/utilis/meals.dart';
import './meals-order.dart';

class MealDetailsScreen extends StatefulWidget {
  final String mealName;

  const MealDetailsScreen({super.key, required this.mealName});

  @override
  // ignore: library_private_types_in_public_api
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  late Future<Meals>? futureMealDetails;

  final mealsService = MealsService();
  Future<void> _getMealsDetails() async {
    futureMealDetails = mealsService.fetchMealDetails(widget.mealName);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getMealsDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mealName} Details'),
      ),
      body: FutureBuilder<Meals>(
        future: futureMealDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(snapshot.data!.details ?? 'No details available.'),
              ),
            );
          }
          return Center(child: Text('No details available.'));
        },
      ),
    );
  }
}
