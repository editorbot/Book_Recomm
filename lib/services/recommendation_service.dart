import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recommendation.dart';

class RecommendationService {
  // ← Replace with YOUR real API Gateway invoke URL
  static const String _baseUrl = 'https://nl2al3np1l.execute-api.us-east-1.amazonaws.com/prod';

  Future<List<Recommendation>> getRecommendations({
    required String preferences,
    required String type, // 'books' or 'movies' — to call different endpoints
  }) async {
    final endpoint = type == 'movies' ? '/recommend_movie' : '/recommend'; // adjust if you have separate paths

    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'preferences': preferences}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> recsJson = data['recommendations'] ?? [];
        return recsJson.map((json) => Recommendation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get recommendations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }
}