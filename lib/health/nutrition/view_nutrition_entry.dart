
import 'package:flutter/material.dart';
import 'package:life_help_calandar_project/data/user_database.dart';


// Custom Widgets

// Data

// Finance

// Goal

// Health - Exercise

// Health - Nutrition
import 'package:life_help_calandar_project/health/nutrition/nutrition_entry.dart';
import 'package:life_help_calandar_project/health/nutrition/nutrition_page.dart';

// Health - General

// Home

// Main Layout & Entry Point


class Nutrition_Data_Content extends StatefulWidget {
  const Nutrition_Data_Content({super.key});

  @override
  _Nutrition_Data_Content createState() => _Nutrition_Data_Content();
}

class _Nutrition_Data_Content extends State<Nutrition_Data_Content> {
  Widget? selectedFinancePage;
  late Future<List <Map<String, dynamic>>> _nutrients;
  @override
  void initState() {
    super.initState();
    _nutrients = fetchnutrition();
  }
  @override
  Future<List<Map<String, dynamic>>> fetchnutrition()async{
    final db = await DatabaseHelper().database;
    return await db.query(
      'nutrition',
      orderBy: 'date DESC',
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: selectedFinancePage ?? Column(
          children: [
            FutureBuilder(
                future: _nutrients,
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
                    return const Center(child: Text('No entries have been made.'));}
                  final nutrients = snapshot.data!;
                  return
                    Expanded(child:
                    ListView.builder(
                        itemCount: nutrients.length,
                        itemBuilder: (context, i){
                          final nutrient = nutrients[i];
                          return Card(
                            child: ListTile(
                                title: Text(nutrient['food'] ?? 'N/A'),
                                onTap: (){
                                  setState(() {
                                    selectedFinancePage = NutritionManualEntryPageContent(
                                        id: nutrient['id'],
                                        date: nutrient['date'],
                                        serving_number: nutrient['serving_number'],
                                        food: nutrient['food'],
                                        ingredients: nutrient['ingredients'],
                                        food_category: nutrient['food_category'],
                                        serving_size: nutrient['serving_size'],
                                        serving_unit: nutrient['serving_size_unit'],
                                        serving_description: nutrient['serving_unit'],
                                        nutrients: nutrient['nutrients'],


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
                    selectedFinancePage = NutritionPageContent();
                  });
                },
                child: Text('Back')),
          ],
        )
    );
  }
}