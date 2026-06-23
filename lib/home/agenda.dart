import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:life_help_calandar_project/data/user_database.dart';
import 'package:life_help_calandar_project/home/data_collection_calendar.dart';
import 'package:life_help_calandar_project/home/home_page.dart';

import 'package:life_help_calandar_project/data/weather_api.dart';

class DailyAgenda extends StatefulWidget {
  final DateTime date;
  const DailyAgenda({super.key, required this.date});

  @override
  _DailyAgendaState createState() => _DailyAgendaState();
}

class _DailyAgendaState extends State<DailyAgenda> {
  Map<String, List<Map<String, dynamic>>> _agendaData = {};
  DailyWeatherList? _weatherForDay;
  late String formattedDate;
  Widget? goBack;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat.MMMMEEEEd().format(widget.date);
    _loadAgendaForDay(widget.date);
  }

  Future<void> _loadAgendaForDay(DateTime date) async {
    final emotions = await getEmotionsForDate(date);
    final finances = await getFinancesForDate(date);
    final nutrition = await getNutritionEntriesForDate(date);

    final allGoals = await getGoalsBetweenDates(date, date);
    final filteredGoals = allGoals.where((goal) {
      final occurrences = getGoalOccurrences(
        startDate: DateTime.parse(goal['start_date']),
        endDate: DateTime.parse(goal['end_date']),
        frequencyAmount: goal['frequency_amount'] as int,
        frequencyTime: goal['frequency_time'] as String,
      );
      return occurrences.any((occurrence) =>
      occurrence.year == date.year &&
          occurrence.month == date.month &&
          occurrence.day == date.day);
    }).toList();

    WeatherAlbum? weatherAlbum;
    try {
      weatherAlbum = await fetchWeatherAlbum("46.267332264", "-119.486331388", "imperial");
    } catch (_) {
      weatherAlbum = null;
    }

    DailyWeatherList? todayWeather;
    if (weatherAlbum != null) {
      for (var w in weatherAlbum.days_data) {
        if (w.date.year == date.year && w.date.month == date.month && w.date.day == date.day) {
          todayWeather = w;
          break;
        }
      }
      if (todayWeather == null && date.day != DateTime.now().day) {
        print("No weather data available for selected day.");
      }
    }

    setState(() {
      _agendaData = {
        'emotions': emotions,
        'finances': finances,
        'nutrition': nutrition,
        'goals': filteredGoals,
      };
      _weatherForDay = todayWeather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return goBack == null
        ? Row(
      children: [
        Expanded(
          flex: 3,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          goBack = HomePageContent();
                        });
                      },
                      child: Text('Back'),
                    ),
                    Text(formattedDate, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              if ((_agendaData['goals']?.isEmpty ?? true) && (_agendaData['emotions']?.isEmpty ?? true))
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("No entries for today."),
                ),
              for (int hour = 0; hour < 24; hour++)
                Builder(
                  builder: (_) {
                    final entriesAtHour = _agendaData.entries.expand((entry) => entry.value.where((item) {
                      final dt = DateTime.tryParse(item['datetime'] ?? item['time_of_day'] ?? '');
                      return dt != null && dt.hour == hour;
                    }).map((item) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.containsKey('title'))
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Goal:", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(item['title']),
                                Text(item['goal_content']),
                                Text("Category: ${item['category']}"),
                                Text("${DateFormat('MMMM d, y').format(DateTime.parse(item['start_date']))} to ${DateFormat('MMMM d, y').format(DateTime.parse(item['end_date']))}"),
                                Text("Once every ${item['frequency_amount']} ${item['frequency_time']}(s)"),
                              ],
                            ),
                          if (item.containsKey('emotion_icon'))
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mood:", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("${item['emotion_icon']} ${item['emotion_name']}: ${item['emotion_description'] ?? ''}"),
                              ],
                            ),
                        ],
                      ),
                    ))).toList();

                    if (entriesAtHour.isEmpty) return SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("${hour.toString().padLeft(2, '0')}:00", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ...entriesAtHour,
                        SizedBox(height: 12),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
        VerticalDivider(),
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.all(8),
            children: [
              if (_weatherForDay != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Weather", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image.network(
                                "http://openweathermap.org/img/wn/${_weatherForDay!.weather.first['icon']}@2x.png",
                                width: 40,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text("${_weatherForDay!.weather.first['description']}"),
                            Text("Min: ${_weatherForDay!.temp['min']}°  Max: ${_weatherForDay!.temp['max']}°"),
                            Text("Humidity: ${_weatherForDay!.humidity}%"),
                            Text("Wind: ${_weatherForDay!.windSpeed} mph"),
                            Text("Clouds: ${_weatherForDay!.clouds}%"),
                            Text("Chance of Rain: ${(_weatherForDay!.pop * 100).toStringAsFixed(0)}%"),
                            Text("Sunrise: ${DateFormat.jm().format(_weatherForDay!.sunrise)}"),
                            Text("Sunset: ${DateFormat.jm().format(_weatherForDay!.sunset)}"),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                )
              else if (widget.date.day == DateTime.now().day)
                Text("No weather data available for today.")
              else
                Text("No weather data for this date."),
              Text("Food", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (_agendaData['nutrition'] != null && _agendaData['nutrition']!.isNotEmpty)
                ..._agendaData['nutrition']!.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${item['food']}: Serving ${item['serving_number']}"),
                      Text("Size: ${item['serving_size']} ${item['serving_unit']}"),
                      if (item['food_category'] != null) Text("Category: ${item['food_category']}"),
                      if (item['householdServingFullText'] != null) Text("Serving Description: ${item['householdServingFullText']}"),
                      if (item['nutrients'] != null && item['nutrients'] is List)
                        ...List.from(item['nutrients']).map<Widget>((n) => Text(" - ${n['nutrientName']}: ${n['value']} ${n['unitName']}")),
                    ],
                  ),
                ))
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("No food entries for today."),
                ),
              SizedBox(height: 16),
              Text("Finance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (_agendaData['finances'] != null && _agendaData['finances']!.isNotEmpty)
                ..._agendaData['finances']!.map((item) => ListTile(
                  title: Text(item['finance_category'] ?? 'Unknown'),
                  subtitle: Text(item['finance_note'] ?? ''),
                  trailing: Text(item['finance_amount'].toString()),
                ))
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("No finance entries for today."),
                )
            ],
          ),
        ),
      ],
    )
        : goBack!;
  }
}
