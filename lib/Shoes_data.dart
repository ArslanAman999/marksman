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
  final response = await http.get(Uri.parse('$apiUrl/shoes'));

  if (response.statusCode == 200) {
    // Response body is a JSON string like:
    // [{"id":1,"name":"Charm Walk Beige",...}, {...}, ...]
    // jsonDecode converts that string into a Dart List
    final List<dynamic> data = jsonDecode(response.body);

    // Convert each item in the list into a Shoes object
    // using the fromJson method we just added
    return data.map((json) => Shoes.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load shoes from API');
  }
}