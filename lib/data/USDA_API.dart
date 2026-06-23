
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<FoodAlbum> fetchFoodAlbum(String search, String dataType, String brand) async {
  String apiKey= " ";
  String url = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=$apiKey&query=$search&sortOrder=desc&dataType=$dataType";
  if (dataType == "Branded" && brand != ''){
    url += "&brandOwner=$brand";
  }
  final response = await http.get(
      Uri.parse(url)
  );
  if (response.statusCode == 200) {
    print(response.statusCode);
    String dataString = response.body;
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(dataString);
    FoodAlbum levelOne = FoodAlbum.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return levelOne;
  } else {
    print(response.statusCode);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class FoodAlbum {
  final int totalHits;
  final int currentPage;
  final int totalPages;
  final List foods;
  // final List city;
  const FoodAlbum({required this.totalHits, required this.currentPage, required this.totalPages, required this.foods});
  factory FoodAlbum.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'totalHits': int totalHits, 'currentPage': int currentPage, 'totalPages': int totalPages, 'foods': List foods} => FoodAlbum(
          totalHits: totalHits,
          currentPage: currentPage,
          totalPages: totalPages,
          foods: foods
      ),
      _ => throw const FormatException('Failed to load main album.'),
    };
  }
}


class CurrentFood{
  String search = "apple";
  String brand = "";
  String data_type = "Branded";
  late Future<FoodAlbum> futureAlbum;
  Future<FoodAlbum> getAlbum(){
    return futureAlbum;
  }
  void setAlbum(){
    futureAlbum = fetchFoodAlbum(search, data_type, brand);
  }
  void set_search(String newSearch){
    search = newSearch;
    setAlbum();
  }
  void set_brand(String newBrand){
    brand = newBrand;
    setAlbum();
  }
  void set_data_type(String newDataType){
    data_type=newDataType;
    setAlbum();
  }
}
