
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';


// Custom Widgets

// Data
import 'package:life_help_calandar_project/data/user_database.dart';

// Finance

// Goal

// Health - Exercise

// Health - Nutrition

// Health - General

// Home

// Main Layout & Entry Point
import 'package:life_help_calandar_project/main_layout.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,]);
    runApp(const MyApp());
    Future.microtask(()async{
      // await deleteAppDatabase();
    });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'App with Shared Navigation Bar',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple.shade700,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          accentColor: Colors.pinkAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple.shade700,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.shade600,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.purple.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.purple.shade700, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.purple.shade700),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(fontSize: 16),
        ),),
      home: const MainLayout(), // Start with your shared layout
    );
  }
}













