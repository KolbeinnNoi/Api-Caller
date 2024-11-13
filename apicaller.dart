import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io'; // For user input

void main() async {
  final String API_URL = "https://api.themoviedb.org/3/search/movie?";
  final String API_KEY = "api_key=302852b0524e0a01498712a56f6c4d81";

  // Get user input for search query
  stdout.write("Enter a movie title to search: ");
  String userQuery = stdin.readLineSync() ?? "";

  if (userQuery.isEmpty) {
    print("No search query provided. Exiting.");
    return;
  }

  // Replace spaces with '+' for URL encoding
  String query = "query=${Uri.encodeComponent(userQuery)}&";

  // Fetch movies
  List<Movie> movies = await fetchMovie(API_URL, query, API_KEY);

  // Display results
  if (movies.isEmpty) {
    print("No movies found for your search query.");
  } else {
    for (var movie in movies) {
      print(movie);
      print("----------------------");
    }
  }
}

Future<List<Movie>> fetchMovie(String url, String query, String apiKey) async {
  try {
    final response = await http.get(Uri.parse(url + query + apiKey));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Movie> movies = [];
      for (var result in jsonResponse['results']) {
        Movie movie = Movie(
          title: result['title'] ?? 'No Title',
          releaseDate: result['release_date'] ?? 'Unknown',
          tagline: result['overview'] ?? 'No Overview',
          imdbScore: result['vote_average']?.toDouble() ?? 0.0,
        );
        movies.add(movie);
      }
      return movies;
    } else {
      print("Error: Unable to fetch movies. Status code: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Error: $e");
    return [];
  }
}

class Movie {
  final String title;
  final String releaseDate;
  final String tagline;
  final double imdbScore;

  Movie({
    required this.title,
    required this.releaseDate,
    required this.tagline,
    required this.imdbScore,
  });

  @override
  String toString() {
    return "Title: $title\nRelease Date: $releaseDate\nIMDb Score: $imdbScore\nOverview: $tagline";
  }
}
