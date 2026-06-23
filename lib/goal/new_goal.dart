
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';



// Custom Widgets
import 'package:life_help_calandar_project/custom_widgets/date_dropdown_selector.dart';
import 'package:life_help_calandar_project/custom_widgets/time_dropdown_selector.dart';

// Data
import 'package:life_help_calandar_project/data/user_database.dart';
import 'package:life_help_calandar_project/goal/goal_insert.dart';
import 'package:intl/intl.dart';

// Finance

// Goal

// Health - Exercise

// Health - Nutrition

// Health - General

// Home

// Main Layout & Entry Point


//---------------------------------------------------------------------------




class NewGoalContent extends StatefulWidget {
  final Widget LastPage;
  final int? id;
  final String? category;
  final String? title;
  final String? start_date;
  final String? end_date;
  final String? time_of_day;
  final int? frequency_amount;
  final String? frequency_time;
  final String? goal_content;
  final int? goal_complete;
// goal_complete INTEGER,
// parent_id INTEGER,
  const NewGoalContent
      ({super.key,
    required this.title,
    required this.LastPage
    ,required this.id
    ,required this.category
    ,required this.start_date
    ,required this.end_date
    ,required this.time_of_day
    ,required this.frequency_amount
    ,required this.frequency_time
    ,required this.goal_content
    ,required this.goal_complete
      });

  @override
  _NewGoalContentState createState() => _NewGoalContentState();
}

class _NewGoalContentState extends State<NewGoalContent> {

  Widget? go_back;
  // bool Mon = false;
  // bool Tue = false;
  // bool Wed = false;
  // bool Thu = false;
  // bool Fri = false;
  // bool Sat = false;
  // bool Sun = false;
  String? selectedCategory;
  List<String> categories = ['Nutrition', 'Exercise', 'Mental Health', 'Finances', "Other"];
  List<String> time_category = ["Day","Week", "Month", "Year"];

  bool ischeck = false;
  final title_controler = TextEditingController();
  final frequency_amount_controller = TextEditingController();
  final goal_content_controller = TextEditingController();

  late DateTime? start_time;
  late DateTime? end_time;
  late DateTime? at_time;

  late String frequency_time;
  @override

  void initState(){
    super.initState();
    super.initState();
    _loadDatabase();

    selectedCategory = widget.category ?? categories.first;
    title_controler.text = widget.title ?? '';
    goal_content_controller.text = widget.goal_content ?? '';
    frequency_time = widget.frequency_time ?? time_category.first;
    frequency_amount_controller.text = widget.frequency_amount?.toString() ?? '';

    // Safely parse datetime strings
    final parsedStart = DateTime.tryParse(widget.start_date ?? '');
    final parsedEnd = DateTime.tryParse(widget.end_date ?? '');
    final parsedTime = DateTime.tryParse(widget.time_of_day ?? '');

    start_time = parsedStart ?? DateTime.now();
    end_time = parsedEnd ?? start_time!.add(Duration(days: 7));
    at_time = parsedTime ?? DateTime(0, 1, 1, 8); // Default to 8 AM

    ischeck = widget.goal_complete == 1;
  }
  Future<void> _loadDatabase() async{
    final db = await DatabaseHelper().database;
    final goals = await db.query("goals", orderBy: 'start_date DESC');}

  @override
  Widget build(BuildContext context) {
    return go_back ?? SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  children: [
                    Text("Goal Category:"),
                    DropdownButton(
                        value: selectedCategory,
                        items: categories.map<DropdownMenuItem<String>>((String category){
                          return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category)
                          );
                        }).toList(),
                        onChanged: (String? newCategory) {setState(() {
                          selectedCategory = newCategory!;
                        });}
                    ),
                    Text("Goal Title:"),
                    SizedBox(
                        width: 200,
                        child: TextField(
                          controller: title_controler,
                            maxLength: 20,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced
                        ))
                  ],
                ),
                // collects goal category

                // start_date TEXT as date,
                Wrap(
                  children: [
                    Text('Start Date:'),
                    DateDropdownSelector(
                      initialDate: start_time,
                      onDateChanged:(date){
                        setState(() {
                          start_time = date;
                        });
                      }
                    ),
                    Text('End Date:'),// end_date TEXT as date,
                    DateDropdownSelector(
                      initialDate: end_time,
                        onDateChanged:(date){
                          setState(() {
                            end_time = date;
                          });
                        }
                    ),
                    Text("Time of Day:"),
                    TimeDropdown(
                      initialTime: at_time,
                      onTimeSelected: (DateTime time){
                        at_time = time;
                      }
                    ),
                  ],
                ),


                // time_of_day TEXT as date,


                // days_of_week TEXT as list of bools,
                // Wrap(
                //   children: [
                //     Text("Sunday:"),
                //     Checkbox(
                //         value: Sun,
                //         onChanged: (bool? change){
                //           setState(() {
                //             Sun = change!;
                //           });
                //         }
                //     ),
                //     Text("Monday:"),
                //     Checkbox(
                //       value: Mon,
                //       onChanged: (bool? change){
                //         setState(() {
                //           Mon = change!;
                //         });
                //       },
                //
                //     ),
                //     Text("Tuesday:"),
                //     Checkbox(
                //         value: Tue,
                //         onChanged: (bool? change){
                //           setState(() {
                //             Tue = change!;
                //           });
                //         }
                //     ),
                //     Text("Wednesday:"),
                //     Checkbox(
                //         value: Wed,
                //         onChanged: (bool? change){
                //           setState(() {
                //             Wed = change!;
                //           });
                //         }
                //     ),
                //     Text("Thursday:"),
                //     Checkbox(
                //         value: Thu,
                //         onChanged: (bool? change){
                //           setState(() {
                //             Thu = change!;
                //           });
                //         }
                //     ),
                //     Text("Friday:"),
                //     Checkbox(
                //         value: Fri,
                //         onChanged: (bool? change){
                //           setState(() {
                //             Fri = change!;
                //           });
                //         }
                //     ),
                //     Text("Saturday:"),
                //     Checkbox(
                //         value: Sat,
                //         onChanged: (bool? change){
                //           setState(() {
                //             Sat = change!;
                //           });
                //         }
                //     ),
                //   ],
                // ),

                // frequency_amount INTEGER,
                Wrap(
                  children: [
                    Text('Once every:'),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: frequency_amount_controller,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ]
                      ),), // frequency_time TEXT as time,
                      DropdownMenu(
                        initialSelection: frequency_time,
                          onSelected: (String? newValue){
                            setState(() {
                              frequency_time = newValue!;
                            });
                          },
                          dropdownMenuEntries: time_category.map(
                              (String category) {
                                return DropdownMenuEntry<String>(value: category, label: category);
                              }).toList()

                      ),



                  ],
                ),
                Wrap(
                  children: [
                    // goal_content TEXT,
                    Text('Goal Description:'),
                    SizedBox(
                      width: 500,
                      child: TextField(
                        controller: goal_content_controller,
                        maxLength: 200,
                        maxLines: 5,
                        minLines: 1,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      ),),
                    Text("Goal Complete?:"),
                    Checkbox(
                        value: ischeck,
                        onChanged:(bool? value){
                      setState(() {
                        ischeck = value!;
                      });
                    })
                    // goal_complete INTEGER,
                  ],
                )
                // parent_id INTEGER,
                //

              ],
            ),
            Wrap(
              spacing: 100,
              children: [
                ElevatedButton(
                    onPressed:(){
                      setState((){
                        prep_goal_data(
                            widget.id,
                            selectedCategory!,
                            title_controler.text,
                            start_time!,
                            end_time!,
                            at_time!,
                            // Sun, Mon, Tue, Wed, Thu, Fri, Sat,
                            frequency_amount_controller.text,
                            frequency_time,
                            goal_content_controller.text,
                            ischeck
                        );
                        go_back = widget.LastPage;
                      });
                    },
                    child: Text('Submit')),
                ElevatedButton(
                    onPressed:(){
                      setState((){

                        go_back = widget.LastPage;
                      });
                    },
                    child: Text('back')),
                ElevatedButton(
                    onPressed:(){
                      setState((){
                        if(widget.id!= null){
                          deleteItem("goals", widget.id!);
                        }
                        go_back = widget.LastPage;
                      });
                    },
                    child: Text('Delete')),
              ],
            )

          ],
        )
    );
  }
}