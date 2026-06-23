
import 'package:flutter/material.dart';


// Custom Widgets

// Data

// Finance

// Goal

// Health - Exercise
import 'package:life_help_calandar_project/health/exercise/exercise_page.dart';

// Health - Nutrition

// Health - General

// Home

// Main Layout & Entry Point

class ExerciseEntryPageContent extends StatefulWidget {
  const ExerciseEntryPageContent({super.key});

  @override
  _ExerciseEntryPageContentState createState() => _ExerciseEntryPageContentState();
}

class _ExerciseEntryPageContentState extends State<ExerciseEntryPageContent> {
  Widget? selectedHealthPage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: selectedHealthPage == null ? Row(

        children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedHealthPage = ExercisePageContent();
                });
              },
              child: Text("back")
          ),
        ],
      )
          : selectedHealthPage!,
    );
  }
}