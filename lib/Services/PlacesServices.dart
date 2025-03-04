import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesService {
  final String apiKey = 'AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E'; // Replace with your API key
  final String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  Future<List<String>> getSchoolSuggestions(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
        '$baseUrl?input=$query&types=school&key=$apiKey'
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return (data['predictions'] as List)
              .map((prediction) => prediction['description'] as String)
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching suggestions: $e');
      return [];
    }
  }

  // Optional: Get place details
  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final detailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
    final url = Uri.parse('$detailsUrl?place_id=$placeId&key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return data['result'];
        }
      }
      return {};
    } catch (e) {
      print('Error fetching place details: $e');
      return {};
    }
  }
}