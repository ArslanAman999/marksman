import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Shoes.dart';

// The URL of our local Node.js API
//const String apiUrl = 'http://localhost:3000';
const String apiUrl = 'https://marksman-api.vercel.app';
// Fetches all shoes from the API
// Returns a List of Shoes objects built from the JSON response
// The 'async' keyword means this runs in the background
// without freezing the UI while waiting for the response
Future<List<Shoes>> fetchShoes() async {
  try {
    final response = await http.get(Uri.parse('$apiUrl/shoes'));
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('Number of shoes: ${data.length}');
      print('First shoe raw: ${data[0]}');

      final shoes = data.map((json) => Shoes.fromJson(json)).toList();
      print('Parsed shoes: ${shoes.length}');
      return shoes;
    } else {
      throw Exception('Failed to load shoes: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in fetchShoes: $e');
    throw Exception('Failed to load shoes from API: $e');
  }
}
