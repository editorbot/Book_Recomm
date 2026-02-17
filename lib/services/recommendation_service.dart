import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recommendation.dart';

class RecommendationService {
  static const String _baseUrl = 'https://nl2al3np1l.execute-api.us-east-1.amazonaws.com/prod';

  Future<List<Recommendation>> getRecommendations({
    required String preferences,
    required String type,
  }) async {
    print('🌐 === API CALL STARTED ===');
    print('🌐 Input type: $type');
    print('🌐 Input preferences: $preferences');

    final lowercaseType = type.toLowerCase();
    print('🌐 Lowercase type: $lowercaseType');

    final endpoint = lowercaseType == 'movies' ? '/recommend_movie' : '/recommend';
    print('🌐 Endpoint selected: $endpoint');

    final url = Uri.parse('$_baseUrl$endpoint');
    print('🌐 Full URL: $url');

    try {
      print('🌐 Sending POST request...');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'preferences': preferences}),
      );

      print('🌐 Response Status Code: ${response.statusCode}');
      print('🌐 Response Headers: ${response.headers}');
      print('🌐 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🌐 Decoded data: $data');

        final List<dynamic> recsJson = data['recommendations'] ?? [];
        print('🌐 Number of recommendations: ${recsJson.length}');

        if (recsJson.isEmpty) {
          print('⚠️ WARNING: No recommendations in response!');
        }

        final recommendations = recsJson.map((json) {
          print('🌐 Parsing recommendation: $json');
          return Recommendation.fromJson(json);
        }).toList();

        print('🌐 === API CALL SUCCESS === Returning ${recommendations.length} items');
        return recommendations;
      } else {
        print('❌ API returned error status: ${response.statusCode}');
        print('❌ Error body: ${response.body}');
        throw Exception('Failed to get recommendations: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ === API CALL FAILED ===');
      print('❌ Exception: $e');
      throw Exception('Error calling API: $e');
    }
  }
}