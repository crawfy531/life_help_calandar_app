import 'package:flutter/material.dart';
import 'dart:async';


// Custom Widgets

// Data
import 'package:life_help_calandar_project/data/USDA_API.dart';

// Finance

// Goal

// Health - Exercise

// Health - Nutrition
import 'package:life_help_calandar_project/health/nutrition/nutrition_entry.dart';
import 'package:life_help_calandar_project/health/nutrition/nutrition_page.dart';

// Health - General

// Home

// Main Layout & Entry Point

class NutritionEntryPageContent extends StatefulWidget {
  const NutritionEntryPageContent({super.key});

  @override
  _NutritionEntryPageContentState createState() => _NutritionEntryPageContentState();
}

class _NutritionEntryPageContentState extends State<NutritionEntryPageContent> {
  Widget? selectedHealthPage;
  CurrentFood FoodSearch = CurrentFood();
  late Future<FoodAlbum> futureFoodAlbum;

  @override

  void initState() {
    super.initState();
    FoodSearch.setAlbum();
    futureFoodAlbum = FoodSearch.getAlbum();
  }

  @override

  Widget build(BuildContext context) {
    return Center(
      child: selectedHealthPage == null ? Row(
        children: [
          FutureBuilder<FoodAlbum>(
              future: futureFoodAlbum,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  final foods = snapshot.data!.foods;

                  return Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            floating: true,
                            title:
                            Row(
                              children: [
                                Expanded(
                                  child: SearchBar(
                                      onChanged:(String? newValue) {
                                        setState(() {
                                          FoodSearch.set_search(newValue.toString());
                                          futureFoodAlbum = FoodSearch.getAlbum();
                                        });
                                      }
                                  ),
                                ),
                                FoodSearch.data_type == "Branded" ?
                                Expanded(
                                  child:
                                  SearchBar(
                                      onChanged:(String? newValue) {
                                        setState(() {
                                          FoodSearch.set_brand(newValue.toString());
                                          futureFoodAlbum = FoodSearch.getAlbum();
                                        });
                                      }
                                  ),
                                )
                                    : Container(),

                                DropdownMenu(
                                    label: Text('data type'),
                                    dropdownMenuEntries: [
                                      DropdownMenuEntry(value: 'Branded', label: 'Branded'),
                                      DropdownMenuEntry(value: 'Survey (FNDDS)', label: 'Survey (FNDDS)'),
                                      DropdownMenuEntry(value: 'SR Legacy', label: 'SR Legacy'),
                                      DropdownMenuEntry(value: 'Foundation', label: 'Foundation'),
                                    ],
                                    onSelected: (String? newValue){
                                      setState(() {
                                        FoodSearch.set_data_type(newValue.toString());
                                        futureFoodAlbum = FoodSearch.getAlbum();

                                      });
                                    }
                                )
                                // (onPressed: null, child: Text('Branded, Survey (FNDDS), SR Legacy, Foundation'))
                              ],
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index){
                                final food = foods[index];
                                return Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      ListTile(
                                        // gtinUpc, brandOwner, brandName, ingredients, marketCountry, foodCategory
                                        title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("UPC: ${food['gtinUpc']}" ?? 'no description'),
                                              Text(food['description']?.toString() ?? 'no description'),
                                              Text(food['brandOwner']?.toString() ?? 'no description'),
                                              Text(food['brandName']?.toString() ?? 'no description'),
                                              Text(food['marketCountry']?.toString() ?? 'no description'),
                                              Text(food['foodCategory']?.toString() ?? 'no description'),
                                              Text(food['ingredients']?.toString() ?? 'no description'),
                                            ]),
                                        tileColor: Colors.deepPurple.shade100
                                      ),
                                    ],)
                                );
                              },
                              childCount: foods.length,
                            ),
                          ),
                        ],
                      )
                  );
                }

                else if (snapshot.hasError){
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();

              }
          ),
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedHealthPage = NutritionPageContent();
                    });
                  },
                  child: Text("back")
              ),
            ],
          ),
        ],
      )
          : selectedHealthPage!,
    );
  }
}