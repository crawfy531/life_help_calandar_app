import 'package:flutter/material.dart';
import 'dart:async';

import 'package:table_calendar/table_calendar.dart';

// Custom Widgets

// Data
import 'package:life_help_calandar_project/data/weather_api.dart';
// Finance

// Goal

// Health - Exercise

// Health - Nutrition

// Health - General

// Home
import 'package:life_help_calandar_project/home/agenda.dart';

// Main Layout & Entry Point

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});


  @override
  _HomePageContent createState() => _HomePageContent();
}

class _HomePageContent extends State<HomePageContent> {
  DateTime today = DateTime.now();
  Widget? daySelect;
  CurrentWeather WeatherNow = CurrentWeather();
  late Future<WeatherAlbum> futureWeatherAlbum;

  @override
  void initState() {
    super.initState();
    WeatherNow.setAlbum();
    futureWeatherAlbum = WeatherNow.getAlbum();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: daySelect == null ?
      FutureBuilder(
          future: futureWeatherAlbum,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                  children: [

                    TableCalendar(
                        availableGestures: AvailableGestures.none,
                        rowHeight:100,
                        focusedDay: today,
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month', // disables toggling to 2-week or week view
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            daySelect = DailyAgenda(date: selectedDay,);
                          });
                        },
                        calendarBuilders:
                        CalendarBuilders(
                          defaultBuilder:
                              (context, day, focusedDay) {
                            final normalizedDay = DateTime(day.year, day.month, day.day);
                            String? icon;
                            double? high;
                            double? low;
                            double? temp;
                            if(snapshot.hasData){
                              for(var item in snapshot.data!.days_data){
                                final itemDate = DateTime(item.date.year, item.date.month, item.date.day);
                                if(itemDate == normalizedDay){
                                  icon = item.weather[0]['icon'];
                                  high = (item.temp['max'] as num).toDouble();
                                  low = (item.temp['min'] as num).toDouble();
                                }
                              }
                            }
                            return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400), // 👈 visible border
                                ),
                                child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: [
                                    Text("${day.day}"),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [

                                        if(high != null && low != null)
                                          Column(
                                              children:[
                                                Text("High:${high.toInt()}\u00B0F"),
                                                Text("Low:${low.toInt()}\u00B0F"),
                                                if (icon != null)
                                                  Container(
                                                    padding: EdgeInsets.all(2),
                                                    color: Colors.black,
                                                    child: Image.network(
                                                      "https://openweathermap.org/img/wn/$icon@2x.png",
                                                      height: 24,
                                                      width: 24,
                                                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.white),
                                                    ),
                                                  )


                                              ]
                                          )

                                      ],
                                    ),

                                  ],
                                ));
                          },
                        )
                    )
                  ]
              ),
            );
          }
      )
          : daySelect!,
    );
  }
} 