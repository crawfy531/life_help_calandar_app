

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_help_calandar_project/health/mental_health/insert_mental_health.dart';


// Custom Widgets
import 'package:life_help_calandar_project/custom_widgets/date_dropdown_selector.dart';
import 'package:life_help_calandar_project/custom_widgets/time_dropdown_selector.dart';
// Data
import 'package:life_help_calandar_project/data/user_database.dart';
// Health - Mental Health
import 'package:life_help_calandar_project/health/mental_health/mental_health.dart';



class Emoji_Rating{
  final int? rank;
  final String? emoji;
  Emoji_Rating(this.rank, this.emoji);
}

class MentalHealthEntry extends StatefulWidget {
  final Widget LastPage;
  final int? id;
  final String? emotion_icon;
  final String? emotion_description;
  final String? emotion_name;
  final String? datetime;
  final int? emotion_rank;

// goal_complete INTEGER,
// parent_id INTEGER,
  const MentalHealthEntry
      ({super.key, 
    required this.LastPage,
    required this.id,
    required this.emotion_icon,
    required this.emotion_description,
    required this.emotion_name,
    required this.datetime,
    required this.emotion_rank

  });
  @override
  _MentalHealthEntry createState() => _MentalHealthEntry();
}
class _MentalHealthEntry extends State<MentalHealthEntry> {
  final emotion_description_controller = TextEditingController();
  final emotion_name_controller = TextEditingController();
  final date_time_controller = TextEditingController();
  final emotion_rank_controller = TextEditingController();
  Widget? selectMentalHealthPage;
  int? selectedRating;
  late Emoji_Rating emoji_rating;
  late DateTime? selected_date;
  late DateTime? selected_time;
  late
  final Map<int, String> emojiScale = {
    1: '😭',
    2: '😢',
    3: '😞',
    4: '😕',
    5: '😐',
    6: '🙂',
    7: '😊',
    8: '😃',
    9: '😁',
    10: '🤩',
  };
  @override

  // widget.id,
  // emoji_rating!.emoji!,
  // emoji_rating!.rank!,
  // emotion_description_controller.text,
  // emotion_name_controller.text,
  // selected_date!,
  // selected_time!);
  void initState(){
    emoji_rating = Emoji_Rating(widget.emotion_rank, widget.emotion_icon);
    selectedRating = widget.emotion_rank;
    emotion_name_controller.text = widget.emotion_name ?? '';
    emotion_description_controller.text = widget.emotion_description ?? '';
    final fullDateTime = DateTime.tryParse(widget.datetime ?? '');

    if (fullDateTime != null) {
      selected_date = DateTime(fullDateTime.year, fullDateTime.month, fullDateTime.day);
      selected_time = DateTime(0, 1, 1, fullDateTime.hour, fullDateTime.minute);
    } else {
      selected_date = DateTime.now();
      selected_time = DateTime(0, 1, 1, 12, 0); // default to noon
    }

  }
  @override
  Widget build(BuildContext context) {
    return selectMentalHealthPage ?? SingleChildScrollView(
        child:  Column(
          children: [
            Column(
              children: [
                // emotion_icon TEXT
                Row(
                  children: [
                    Text('With 1 being the worst and 10 being the best, rank the emotion:')
                  ],
                ),
                Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: emojiScale.entries.map((entry) {
                          final isSelected = selectedRating == entry.key;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRating = entry.key;
                                emoji_rating = Emoji_Rating(entry.key, entry.value);
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.blue[100] : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? Colors.blue : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(entry.key.toString()),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                Row(
                  children: [
                    Text("Name the Emotion:"),
                    Expanded(
                        child: TextField(
                          controller: emotion_name_controller,
                          maxLength: 20,
                          maxLengthEnforcement: MaxLengthEnforcement .enforced,
                        )
                    ),
                  ],
                ),
                // datetime TEXT,
                Row(
                  children: [

                    Text("Input what day this was:"),
                    DateDropdownSelector(
                      onDateChanged: (date){
                        setState(() {
                          selected_date = date;
                        });
                      },
                    ),
                    Text("Time:"),
                    TimeDropdown(
                        onTimeSelected: (DateTime time){
                          selected_time = time;
                        }
                    ),
                  ],
                ),
                // emotion_name TEXT,
                // emotion_description TEXT,
                Row(
                  children: [
                    Text("Additional Note:"),
                    Expanded(
                        child: TextField(
                          controller: emotion_description_controller,
                          maxLength: 200,
                          maxLines: 5,
                          minLines: 1,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        )
                    ),
                  ],
                ),
                // emotion_name TEXT


              ],
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed:(){
                      setState((){
                        selectMentalHealthPage = MentalHealthPageContent();
                      });
                    },
                    child: Text('Back')),
                ElevatedButton(
                    onPressed:(){
                      setState((){
                        if(emoji_rating != null) {
                          prep_mental_health_data(
                              widget.id,
                              emoji_rating!.emoji!,
                              emoji_rating!.rank!,
                              emotion_description_controller.text,
                              emotion_name_controller.text,
                              selected_date!,
                              selected_time!);
                          selectMentalHealthPage = MentalHealthPageContent();
                        }
                      });
                    },
                    child: Text('Submit')),
                ElevatedButton(
                    onPressed:(){
                      setState((){
                        if(widget.id!= null){
                          deleteItem("emotion", widget.id!);
                        }
                        selectMentalHealthPage = MentalHealthPageContent();});
                    },
                    child: Text('Delete')),
              ],
            )

          ],
        )
    );
  }
}