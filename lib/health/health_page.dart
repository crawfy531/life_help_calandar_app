
import 'package:flutter/material.dart';


// Custom Widgets

// Data

// Finance

// Goal

// Health - Exercise
import 'package:life_help_calandar_project/health/exercise/exercise_page.dart';

// Health - Mental Health
import 'package:life_help_calandar_project/health/mental_health/mental_health.dart';


// Health - Nutrition
import 'package:life_help_calandar_project/health/nutrition/nutrition_page.dart';

// Health - General

// Home

// Main Layout & Entry Point

class HealthPageContent extends StatefulWidget {
  const HealthPageContent({super.key});

  @override
  _HealthPageContentState createState() => _HealthPageContentState();
}

class _HealthPageContentState extends State<HealthPageContent> {
  Widget? selectedHealthPage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: selectedHealthPage == null
          ? Row( children: [

        Column(
          children: [
            ElevatedButton(onPressed: () {
              setState(() {
                selectedHealthPage = ExercisePageContent();
              });
            },
              child: const Text('Exercise'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedHealthPage = NutritionPageContent();
                });
              },
              child: const Text('Nutrition'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedHealthPage = MentalHealthPageContent();
                });
              },
              child: const Text('Mental Health'),
            ),
          ],
        ),
      ]
      )



          : selectedHealthPage!,
    );
  }
}