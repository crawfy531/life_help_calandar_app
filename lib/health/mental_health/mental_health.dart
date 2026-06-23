
import 'package:flutter/material.dart';


// Custom Widgets

// Data

// Finance

// Goal
import 'package:life_help_calandar_project/goal/new_goal.dart';

// Health - Exercise

// Health - Nutrition

// Health - Mental Health
import 'package:life_help_calandar_project/health/mental_health/mental_health_graph.dart';
import 'package:life_help_calandar_project/health/mental_health/mental_health_entry.dart';
import 'package:life_help_calandar_project/health/mental_health/view_mental_health.dart';

import 'package:life_help_calandar_project/data/user_database.dart';

// Health - General
import 'package:life_help_calandar_project/health/health_page.dart';

// Home

// Main Layout & Entry Point

class MentalHealthPageContent extends StatefulWidget {
  const MentalHealthPageContent({super.key});

  @override
  _MentalHealthPageContent createState() => _MentalHealthPageContent();
}

class _MentalHealthPageContent extends State<MentalHealthPageContent> {
  Widget? selectedHealthPage;
  late Future<List <Map<String, dynamic>>> _mental_health_Goals;
  @override
  void initState(){
    super.initState();
    _mental_health_Goals = fetch_mental_health_Goals();
  }
  Future<List<Map<String, dynamic>>> fetch_mental_health_Goals()async{
    final db = await DatabaseHelper().database;
    return await db.query(
      'goals',
      where: 'category = ?',
      whereArgs: ['Mental Health'],
      orderBy: 'start_date DESC',
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: selectedHealthPage == null ?
      Row(
        children: [
          Expanded(child:MentalHealthLineChart(),),
          FutureBuilder(
              future: _mental_health_Goals,
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
                                    category: "Mental Health",
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
            children: [ElevatedButton(
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
                      selectedHealthPage = MentalHealthEntry(LastPage: widget, id: null, emotion_icon: null, emotion_description: null, emotion_name: null, datetime: null, emotion_rank: null);
                    });
                  },
                  child: Text('new entry')
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedHealthPage = Mental_Data_Content();
                    });
                  },
                  child: Text('view entries')
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedHealthPage = NewGoalContent(LastPage: widget, id: null, category: "Mental Health",title: null, start_date: null, end_date: null, time_of_day: null, frequency_amount: null, frequency_time: null, goal_content: null, goal_complete: null);
                    });
                  },
                  child: Text('new goal')
              ),],
          )

        ],
      )
          : selectedHealthPage!,
    );
  }
}