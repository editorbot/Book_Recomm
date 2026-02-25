class Recommendation {
  final String title;
  final String? authorOrDirector;   // author for books, director for movies
  final String summaryOrPlot;
  final int matchScore;
  final List<String>? genres;       // only for movies, optional
  final String? posterPath;  // for both

  Recommendation({
    required this.title,
    this.authorOrDirector,
    required this.summaryOrPlot,
    required this.matchScore,
    this.genres,
    this.posterPath
  });

  // Factory to create from JSON (your Lambda returns this format)
  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      title: json['title'] as String,
      authorOrDirector: json['author'] ?? json['director'],
      summaryOrPlot: json['summary_snippet']  ?? 'No description available',
      matchScore: json['score'] as int? ?? 0,
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      posterPath: json['posterPath'] ?? 'No posters'
    );
  }
}