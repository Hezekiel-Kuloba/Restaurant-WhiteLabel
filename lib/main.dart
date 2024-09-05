import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/screens/meals/meals.dart';

import './screens/authentication/login.dart';
import './screens/authentication/register.dart';
import './screens/tabs.dart';
import './screens/home.dart';
import './screens/meals/meal-add.dart';

final theme = ThemeData(
  brightness:
      Brightness.light, // Use light theme for orange on white background
  primaryColor: Colors.orange,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.orange,
    primary: Colors.orange,
    secondary: Colors.white,
    background: Colors.white,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.orange,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    bodyLarge: const TextStyle(color: Colors.black),
    bodyMedium: const TextStyle(color: Colors.black),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white, // Text color for AppBar
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.orange, // Button text color
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.orange, // Text button color
    ),
  ),
);

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      // home: const TabsScreen(),
      home: const Login(),
      // home: const Register(),
      // home: const HomeScreen(),
      // home: const Meal(),
      // home: const MealApp(),
    );
  }
}
