
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
import 'package:life_help_calandar_project/health/nutrition/nutrition_entry.dart';
import 'package:life_help_calandar_project/health/nutrition/Food_search.dart';
import 'package:life_help_calandar_project/health/nutrition/view_nutrition_entry.dart';

// Health - General
import 'package:life_help_calandar_project/health/health_page.dart';

// Home

// Main Layout & Entry Point

class NutritionPageContent extends StatefulWidget {
  const NutritionPageContent({super.key});

  @override
  _NutritionPageContentState createState() => _NutritionPageContentState();
}

class _NutritionPageContentState extends State<NutritionPageContent> {
  Widget? selectedHealthPage;
  late Future<List <Map<String, dynamic>>> _nutritionGoals;
  @override
  void initState(){
    super.initState();
    _nutritionGoals = fetchNutritionGoals();
  }
  Future<List<Map<String, dynamic>>> fetchNutritionGoals()async{
    final db = await DatabaseHelper().database;
    return await db.query(
      'goals',
      where: 'category = ?',
      whereArgs: ['Nutrition'],
      orderBy: 'start_date DESC',
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: selectedHealthPage == null ?
      Row( children: [
        Expanded(child:
        Row(
            children: [
              FutureBuilder(
                  future: _nutritionGoals,
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
                      return const Center(child: Text('No Nutrition goals have been made.'));}
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
                                        category: "Nutrition",
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
            ])),
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedHealthPage = HealthPageContent();
                });
              },
              child: Text('back'),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedHealthPage = NutritionManualEntryPageContent(id: null, date: null, serving_number: null, food: null, ingredients: null, food_category: null, serving_size: null, serving_unit: null);
                  });
                },
                child: Text('new entry')
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedHealthPage = NutritionEntryPageContent();
                  });
                },
                child: Text('automated entry')
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedHealthPage = Nutrition_Data_Content();
                  });
                },
                child: Text('view entries')
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedHealthPage = NewGoalContent(LastPage: widget, id: null, category: "Nutrition", title: null , start_date: null, end_date: null, time_of_day: null, frequency_amount: null, frequency_time: null, goal_content: null, goal_complete: null);
                  });
                },
                child: Text('new goal')
            ),
          ],
        )
      ]
      ): selectedHealthPage!,
    );
  }
}