
import 'package:flutter/material.dart';
import 'dart:async';


// Custom Widgets

// Data
import 'package:life_help_calandar_project/data/user_database.dart';

// Finance

// Goal
import 'package:life_help_calandar_project/goal/new_goal.dart';

// Health - Exercise

// Health - Nutrition

// Health - General
import 'package:life_help_calandar_project/health/health_page.dart';

// Home

// Main Layout & Entry Point

class ExercisePageContent extends StatefulWidget {
  const ExercisePageContent({super.key});

  @override
  _ExercisePageContentState createState() => _ExercisePageContentState();
}

class _ExercisePageContentState extends State<ExercisePageContent> {
  Widget? selectedHealthPage;
  late Future<List <Map<String, dynamic>>> _fitnessGoals;
  @override
  void initState(){
    super.initState();
    _fitnessGoals = fetchFitnessGoals();
  }
  @override
  Future<List<Map<String, dynamic>>> fetchFitnessGoals()async{
    final db = await DatabaseHelper().database;
    return await db.query(
      'goals',
      where: 'category = ?',
      whereArgs: ['Exercise'],
      orderBy: 'start_date DESC',
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: selectedHealthPage == null ?
      Row(
          children: [
            Text('data'),
            Expanded(child:
            Row(
                children: [
                  FutureBuilder(
                      future: _fitnessGoals,
                      builder: (contect, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting){
                          return const Center(
                              child: CircularProgressIndicator()
                          );
                        }
                        else if(snapshot.hasError){
                          return Center(
                              child: Text('Error')
                          );
                        } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                          return const Center(child: Text('No Exercise goals have been made.'));}
                        final goals = snapshot.data!;
                        return
                          Expanded(child:
                          ListView.builder(
                              itemCount: goals.length,
                              itemBuilder: (context, i){
                                final goal = goals[i];
                                return Card(
                                  child: ListTile(
                                    title: Text(goal['goal_content'] ?? 'N/A'),
                                      onTap: (){
                                        setState(() {
                                          selectedHealthPage = NewGoalContent(
                                            LastPage: widget,
                                            id: goal['id'],
                                            category: "Exercise",
                                            title: goal['title'],
                                            start_date: goal['start_date'],
                                            end_date: goal['end_date'],
                                            time_of_day: goal['time_of_day'],
                                            frequency_amount: goal['frequency_amount'],
                                            frequency_time: goal['frequency_time'],
                                            goal_content: goal['goal_content'],
                                            goal_complete: goal['goal_complete'],
                                          );});}
                                  ),
                                );
                              }
                          ));
                      }
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedHealthPage = NewGoalContent(LastPage: widget, id: null, category: "Exercise", title: null, start_date: null, end_date: null, time_of_day: null, frequency_amount: null, frequency_time: null, goal_content: null, goal_complete: null);
                            });
                          },
                          child: Text('new entry')
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedHealthPage = HealthPageContent();
                          });
                        },
                        child: Text('back'),
                      ),

                    ],
                  )
                ]))
          ])
          : selectedHealthPage!,
    );
  }
}