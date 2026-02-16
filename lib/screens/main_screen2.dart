import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/recommendation.dart';
import '../services/recommendation_service.dart';

class RecommendScreen extends StatefulWidget {
  final String type; // 'Books' or 'Movies'

  const RecommendScreen({super.key, required this.type});

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  final _service = RecommendationService();
  final _preferencesController = TextEditingController();
  List<Recommendation> _recommendations = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _getRecommendations() async {
    if (_preferencesController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _service.getRecommendations(
        preferences: _preferencesController.text.trim(),
        type: widget.type.toLowerCase(),
      );
      setState(() {
        _recommendations = results;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.type} Recommender')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _preferencesController,
              decoration: InputDecoration(
                labelText: 'Your preferences (e.g. "mind-bending sci-fi thrillers")',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _getRecommendations,
              child: Text('Get ${widget.type} Recommendations'),
            ),
            const SizedBox(height: 24),

            if (_isLoading)
              const SpinKitFadingCircle(color: Colors.blue, size: 50.0),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            if (_recommendations.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _recommendations.length,
                  itemBuilder: (context, index) {
                    final rec = _recommendations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rec.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (rec.authorOrDirector != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.type == 'Books' ? 'Author: ${rec.authorOrDirector}' : 'Director: ${rec.authorOrDirector}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Text(
                              rec.summaryOrPlot,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Match Score: ${rec.matchScore}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            if (rec.genres != null && rec.genres!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: rec.genres!.map((g) => Chip(
                                  label: Text(g),
                                  backgroundColor: Colors.blue[100],
                                )).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _preferencesController.dispose();
    super.dispose();
  }
}