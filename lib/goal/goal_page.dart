
import 'package:flutter/material.dart';
import 'package:life_help_calandar_project/data/user_database.dart';


// Custom Widgets

// Data

// Finance

// Goal
import 'package:life_help_calandar_project/goal/new_goal.dart';

// Health - Exercise

// Health - Nutrition

// Health - General

// Home

// Main Layout & Entry Point


class GoalPageContent extends StatefulWidget {
  const GoalPageContent({super.key});

  @override
  _GoalPageContentState createState() => _GoalPageContentState();
}

class _GoalPageContentState extends State<GoalPageContent> {
  Widget? selectedGoalPage;
  late Future<List <Map<String, dynamic>>> _goals;
  @override
  void initState() {
    super.initState();
    _goals = fetchGoals();
  }
  @override
  Future<List<Map<String, dynamic>>> fetchGoals()async{
    final db = await DatabaseHelper().database;
    return await db.query(
      'goals',
      orderBy: 'start_date DESC',
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: selectedGoalPage ?? Column(
          children: [
            FutureBuilder(
                future: _goals,
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
                    return const Center(child: Text('No Goals have been made.'));}
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
                                    selectedGoalPage = NewGoalContent(
                                      LastPage: widget,
                                      id: goal['id'],
                                      category: "Other",
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
            ElevatedButton(
                onPressed:(){
                  setState((){
                    selectedGoalPage = NewGoalContent(LastPage: widget, id: null, category: "Other",title: null, start_date: null, end_date: null, time_of_day: null, frequency_amount: null, frequency_time: null, goal_content: null, goal_complete: null);
                  });
                },
                child: Text('New Goal')),
          ],
        )
    );
  }
}