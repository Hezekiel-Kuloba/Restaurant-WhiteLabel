import 'package:flutter/material.dart';
import 'package:meal_app/screens/authentication/users.dart';
import 'package:meal_app/screens/kitchen/kitchen-rules.dart';
import 'package:meal_app/screens/maps/maps-demo.dart';
import 'package:meal_app/screens/maps/restaurant.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/screens/meals/meals.dart';
import 'package:meal_app/screens/orders/order-for-others.dart';
import 'package:meal_app/screens/orders/order-now.dart';
import 'package:meal_app/screens/orders/orders-all.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Text(
              'Digital Vision',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Orders'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const OrderScreen()), // Replace with actual screen
              );
            },
          ),
          ListTile(
            title: const Text('Order Now'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const OrderNow()), // Replace with actual screen
              );
            },
          ),
          ListTile(
            title: const Text('Order For Alvin'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const OrderOthers()), // Replace with actual screen
              );
            },
          ),
          ListTile(
            title: const Text('Meals'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const MealApp()), // Replace with actual screen
              );
            },
          ),
          ListTile(
            title: const Text('Users'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const UserScreen()), // Replace with actual screen
              );
            },
          ),
          ListTile(
            title: const Text('Restaurants Near Me'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const RestaurantsMapScreen()), // Replace with actual screen
              );
            },
          ),
          ListTile(
            title: const Text('Map Sample State'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const MapSample()), // Replace with actual screen
              );
            },
          ),
          ListTile(
            title: const Text('Rules'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const RulesScreen()), // Replace with actual screen
              );
            },
          ),
        ],
      ),
    );
  }
}
