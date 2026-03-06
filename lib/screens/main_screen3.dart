import 'package:aws_book/models/recommendation.dart';
import 'package:aws_book/services/recommendation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RecScreen extends StatefulWidget {
  final String type; // 'Books' or 'Movies'

  const RecScreen({super.key, required this.type});

  @override
  State<RecScreen> createState() => _RecScreenState();
}

class _RecScreenState extends State<RecScreen> {
  final _service = RecommendationService();
  List<Recommendation> _recommendations = [];
  bool _isLoading = false;
  String? _error;
  late String _selectedType;
  final Set<String> _selectedGenres = {};

  static const List<String> _movieGenres = [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'History',
    'Horror',
    'Music',
    'Mystery',
    'Romance',
    'Science Fiction',
    'Thriller',
  ];

  static const List<String> _bookGenres = [
    'Fiction',
    'Mystery',
    'Thriller',
    'Romance',
    'Science Fiction',
    'Fantasy',
    'Biography',
    'History',
    'Self-Help',
    'Horror',
    'Adventure',
    'Comedy',
    'Drama',
    'Crime',
  ];

  List<String> get _currentGenres =>
      _selectedType == 'Books' ? _bookGenres : _movieGenres;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.type;
  }

  Future<void> _getRecommendations() async {
    if (_selectedGenres.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Join selected chips into a plain text string for Lambda/Comprehend
      final preferencesText = _selectedGenres.join(' ');

      final results = await _service.getRecommendations(
        preferences: preferencesText,
        type: _selectedType.toLowerCase(),
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
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.rocket),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // ── Type selector + label row ──────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pick your genres',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueGrey.shade100),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedType,
                      icon: const Icon(CupertinoIcons.chevron_compact_down),
                      items: const [
                        DropdownMenuItem(value: 'Books', child: Text('Books')),
                        DropdownMenuItem(
                            value: 'Movies', child: Text('Movies')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedType = value;
                            _selectedGenres.clear();
                            _recommendations = [];
                            _error = null;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Genre chips ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey.shade100),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _currentGenres.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                    },
                    selectedColor: Colors.blue.shade100,
                    checkmarkColor: Colors.blue.shade700,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.blue.shade700
                          : Colors.blueGrey.shade700,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    backgroundColor: Colors.blueGrey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.blue.shade300
                            : Colors.blueGrey.shade200,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // ── Selected count hint ────────────────────────────────────
            if (_selectedGenres.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '${_selectedGenres.length} genre${_selectedGenres.length > 1 ? 's' : ''} selected',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey.shade400,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // ── Get Recommendations button ─────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isLoading || _selectedGenres.isEmpty)
                    ? null
                    : _getRecommendations,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Get $_selectedType Recommendations'),
              ),
            ),

            const SizedBox(height: 24),

            // ── Loading / Error / Results ──────────────────────────────
            if (_isLoading)
              const Center(
                child: SpinKitFadingCircle(color: Colors.blue, size: 50.0),
              ),

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
                            if (rec.posterPath != null &&
                                rec.posterPath!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.network(
                                    _selectedType == 'Books'
                                        ? rec.posterPath!
                                        : 'https://image.tmdb.org/t/p/w342${rec.posterPath}',
                                    width: 100,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                      _selectedType == 'Books'
                                          ? Icons.book
                                          : Icons.movie,
                                      size: 100,
                                    ),
                                  ),
                                ),
                              )
                            else
                              const SizedBox(
                                width: 100,
                                height: 150,
                                child: Icon(Icons.movie,
                                    size: 80, color: Colors.grey),
                              ),
                            const SizedBox(height: 12),
                            Text(
                              rec.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (rec.authorOrDirector != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                _selectedType == 'Books'
                                    ? 'Author: ${rec.authorOrDirector}'
                                    : 'Director: ${rec.authorOrDirector}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.grey[700]),
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
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            if (rec.genres != null &&
                                rec.genres!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: rec.genres!
                                    .map((g) => Chip(
                                  label: Text(g),
                                  backgroundColor: Colors.blue[100],
                                ))
                                    .toList(),
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
}