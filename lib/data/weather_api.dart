
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



Future<WeatherAlbum> fetchWeatherAlbum(String lat, String lon, String units) async {
  String apiKey= "190308b128afbf13909a695d4ccbcb4d";

  final response = await http.get(
      Uri.parse("https://api.openweathermap.org/data/2.5/forecast/daily?cnt=16&lat=$lat&lon=$lon&appid=$apiKey&units=$units")
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    print(response.statusCode);
    String dataString = response.body;
    // If the server did return a 200 OK response,
    // then parse the JSON.
    WeatherAlbum levelOne = WeatherAlbum.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

    return levelOne;
  } else {
    print(response.statusCode);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class WeatherAlbum{

  final List<DailyWeatherList> days_data;

  WeatherAlbum({required this.days_data});

  factory WeatherAlbum.fromJson(Map<String, dynamic> json){
    final List list = json['list'];
    final daysData = list.map((entry) => DailyWeatherList.fromJson(entry)).toList();
    return WeatherAlbum(days_data: daysData);

  }
}

class DailyWeatherList{
  final DateTime date;
  final DateTime sunrise;
  final DateTime sunset;
  final Map<String, dynamic> temp;
  final int pressure;
  final int humidity;
  final List weather; // Contains icon, description, etc.
  final double windSpeed;
  final double? windGust; // Might be null sometimes
  final int clouds;
  final double pop;

  DailyWeatherList({
    required this.date,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.pressure,
    required this.humidity,
    required this.weather,
    required this.windSpeed,
    this.windGust,
    required this.clouds,
    required this.pop,
  });

  factory DailyWeatherList.fromJson(Map<String, dynamic> json) {
    return DailyWeatherList(
        date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
        sunrise: DateTime.fromMillisecondsSinceEpoch(json['sunrise'] * 1000),
        sunset: DateTime.fromMillisecondsSinceEpoch(json['sunset'] * 1000),
        temp: json['temp'], // this is a map: day, min, max, night, eve, morn
        pressure: json['pressure'],
        humidity: json['humidity'],
        weather: json['weather'],
        windSpeed: json['speed'].toDouble(),
        windGust: json['gust']?.toDouble(),
        clouds: json['clouds'],
        pop: (json['pop'] ?? 0).toDouble());}


}



class CurrentWeather{
  String lat = "46.267332264";
  String lon ="-119.486331388";
  String units = "imperial";

  late Future<WeatherAlbum> futureAlbum;

  Future<WeatherAlbum> getAlbum(){
    return futureAlbum;
  }
  void setAlbum(){
    futureAlbum = fetchWeatherAlbum(lat, lon, units);

  }
  void set_lat_lon(String newLat, String newLon){
    lat = newLat;
    lon = newLon;
    setAlbum();
  }
  void set_units(String newUnits){
    units = newUnits;
    setAlbum();
  }

}