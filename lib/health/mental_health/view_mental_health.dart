
import 'package:flutter/material.dart';
import 'package:life_help_calandar_project/data/user_database.dart';


// Custom Widgets

// Data

// Finance

// Goal

import 'package:life_help_calandar_project/health/mental_health/mental_health.dart';
import 'package:life_help_calandar_project/health/mental_health/mental_health_entry.dart';

// Health - Exercise

// Health - Nutrition

// Health - General

// Home

// Main Layout & Entry Point


class Mental_Data_Content extends StatefulWidget {
  const Mental_Data_Content({super.key});

  @override
  _Mental_Data_Content createState() => _Mental_Data_Content();
}

class _Mental_Data_Content extends State<Mental_Data_Content> {
  Widget? selectedMentalPage;
  late Future<List <Map<String, dynamic>>> _mental;
  @override
  void initState() {
    super.initState();
    _mental = fetch_mental();
  }
  @override
  Future<List<Map<String, dynamic>>> fetch_mental()async{
    final db = await DatabaseHelper().database;
    return await db.query(
      'emotion',
      orderBy: 'datetime DESC',
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: selectedMentalPage ?? Column(
          children: [
            FutureBuilder(
                future: _mental,
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
                  final mentals = snapshot.data!;
                  return
                    Expanded(child:
                    ListView.builder(
                        itemCount: mentals.length,
                        itemBuilder: (context, i){
                          final ment = mentals[i];
                          return Card(
                            child: ListTile(
                                title: Text(ment['emotion_name'] ?? 'N/A'),
                                onTap: (){
                                  setState(() {
                                    selectedMentalPage = MentalHealthEntry(
                                        LastPage: this.widget,
                                        id: ment['id'],
                                        emotion_icon: ment['emotion_icon'],
                                        emotion_description: ment['emotion_description'],
                                        emotion_name: ment['emotion_name'],
                                        datetime: ment['datetime'],
                                        emotion_rank: ment['emotion_rank']
                                    );
                                  });}
                            ),
                          );
                        }
                    ));
                }
            ),
            ElevatedButton(
                onPressed:(){
                  setState((){
                    selectedMentalPage = MentalHealthPageContent();
                  });
                },
                child: Text('Back')),
          ],
        )
    );
  }
}