import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

enum SearchType { movie, person, tv, multi}

void main(){
  SearchType QueryParameter = SearchType.multi;
  print("What would you like to search for?");
  print("1. Movie");
  print("2. Person");
  print("3. TV");
  String inputQuestion = stdin.readLineSync().toString();
  switch(inputQuestion) {
    case "1":
      QueryParameter = SearchType.movie;
        break;
    case "2":
      QueryParameter = SearchType.person;
      break;
    case "3":
      QueryParameter = SearchType.tv;
      break;
    default:
      QueryParameter = SearchType.multi;
  }

  print("Enter Name of $QueryParameter:");
  String input1 = stdin.readLineSync().toString();
  fetchData(input1,QueryParameter);
}

void fetchData(String query, SearchType parameter) async {
  final String apiUrl = "https://api.themoviedb.org/3/search/${parameter.name}";
  final String apiKey = "302852b0524e0a01498712a56f6c4d81";
  final url = Uri.parse('$apiUrl?query=$query&api_key=$apiKey');
  final response = await http.get(url);
  print(url);
  final jsonResponse = json.decode(response.body);
  switch(parameter) {
    case SearchType.movie:
      fetchMovie(jsonResponse);
      break;
    case SearchType.person:
      fetchActor(jsonResponse);
      break;
    case SearchType.tv:
      fetchTV(jsonResponse);
      break;
    default:
      print("Coming Soon");
  }
}
void fetchMovie(dynamic jsonResponse){
  List<Movie> movies = [];

  for (int i = 0; i < jsonResponse['results'].length; i++) {
    Movie movie = new Movie(title: jsonResponse['results'][i]['title'],
        releaseDate: jsonResponse['results'][i]['release_date'],
        tagline: jsonResponse['results'][i]['overview']);
    movies.add(movie);
    print(movie.toString());
  }
}
void fetchActor(dynamic jsonResponse){
  List<Actor> actors = [];
  for (int i = 0; i < jsonResponse['results'].length; i++) {
    List<dynamic> known_for =  jsonResponse['results'][i]['known_for'];
    String known_for_result = "";
    for(int k = 0;k < known_for.length; k++) {
      known_for_result += known_for[k]['title'] + ",";
    }
    Actor actor = new Actor(
        name: jsonResponse['results'][i]['name'],
        gender: jsonResponse['results'][i]['gender']  == 1 ? "Female" : "Male",
        known_for_department: known_for_result,

    );
    actors.add(actor);
    print(actor.toString());
  }
}
void fetchTV(dynamic jsonResponse){
  List<TV> tvs = [];
  for (int i = 0; i < jsonResponse['results'].length; i++) {
    TV tv = new TV(name: jsonResponse['results'][i]['name'], first_air_date: jsonResponse['results'][i]['first_air_date'].toString(), overview: jsonResponse['results'][i]['overview']);
    tvs.add(tv);
    print(tvs.toString());
  }
}

class Movie {
  final String title;
  final String releaseDate;
  final String tagline;

  Movie({
    required this.title,
    required this.releaseDate,
    required this.tagline
});
  @override
  String toString() {
    return "${title} \n${releaseDate} \n${tagline}";
  }
}

class Actor {
  final String name;
  final String gender;
  final String known_for_department;

  Actor({
    required this.name,
    required this.gender,
    required this.known_for_department
  });
  @override
  String toString() {
    return "${name} \n${gender} \n${known_for_department}";
  }
}
class TV {
final String name;
final String first_air_date;
final String overview;

TV({
  required this.name,
  required this.first_air_date,
  required this.overview
});
@override
String toString() {
  return "${name} \n${first_air_date} \n${overview}";
}
}