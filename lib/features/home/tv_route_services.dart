import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'tv_route_model.dart';

class TvRouteService {
  static Future<List<TvRouteModel>> fetchTvRoutes() async {
    // Retrieve access token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    // Make GET request with authorization header
    final response = await http.get(
      Uri.parse('https://iptv-backend-4798.onrender.com/api/tv/all'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Check response status code
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // parse the JSON response using your model class
      debugPrint('Data fetched');
      List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => TvRouteModel.fromJson(data)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      debugPrint('Failed to fetch data');
      throw Exception('Failed to load TV routes');
    }
  }
}
