import 'package:aws_book/models/recommendation.dart';
import 'package:aws_book/services/recommendation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainScreen extends StatefulWidget {
  final String type; // 'Books' or 'Movies'


  const MainScreen({super.key, required this.type});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _service = RecommendationService();
  final _preferencesController = TextEditingController();
  List<Recommendation> _recommendations = [];
  bool _isLoading = false;
  String? _error;

  late String _selectedType;
  @override
  void initState() {
    super.initState();
    _selectedType = widget.type;  // Start with whatever was passed from parent
    print('🟢 initState - _selectedType: $_selectedType');
    print('🟢 initState - widget.type: ${widget.type}');
  }
  Future<void> _getRecommendations() async {
    if (_preferencesController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _service.getRecommendations(
        preferences: _preferencesController.text.trim(),
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
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.rocket)) ,
        actions: [


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {  }, icon: Icon(Icons.account_circle),
           ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {  }, icon: Icon(Icons.logout),
            ),
          )

        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 46,right: 46),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white
              ),

              child: Column(
                children: [
                  TextField(

                    controller: _preferencesController,
                    decoration: InputDecoration(
                      hintText: 'Your preferences (e.g. "mind-bending sci-fi thrillers")',
                      hintStyle: TextStyle(
                        color: Colors.blueGrey.withAlpha(70),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey.withAlpha(0)
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey.withAlpha(0)
                        )
                      )

                    ),

                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blueGrey.withAlpha(0), ),

                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                          hint: Text(_selectedType),


                            icon: const Icon(CupertinoIcons.chevron_compact_down),
                            items:  const [
                              DropdownMenuItem(
                                value: 'Books',
                                child: Text('Books'),
                              ),
                              DropdownMenuItem(
                                value: 'Movies',
                                child: Text('Movies'),
                              ),
                            ],
                            onChanged: (value) {
                              print('🔵 Dropdown changed to: $value');
                              if (value != null) {
                                setState(() {
                                  print('🔴 Before setState - _selectedType: $_selectedType');
                                  _selectedType = value;
                                  print('🟡 After setState - _selectedType: $_selectedType');
                                  _recommendations = [];
                                  _error = null;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _getRecommendations,
              child: Text('Get ${_selectedType} Recommendations'),
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
                            if (rec.posterPath != null && rec.posterPath!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.network(
                                                                 _selectedType=='Books' ? rec.posterPath! :  'https://image.tmdb.org/t/p/w342${rec.posterPath}',  // w342 or w500 for good quality/size
                                    width: 100,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>  Icon(  _selectedType=='Books'? Icons.book: Icons.movie, size: 100),
                                  ),
                                ),
                              )
                            else
                              const SizedBox(
                                width: 100,
                                height: 150,
                                child: Icon(Icons.movie, size: 80, color: Colors.grey),
                              ),
                            const SizedBox(width: 16),
                            Text(
                              rec.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (rec.authorOrDirector != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                _selectedType == 'Books' ? 'Author: ${rec.authorOrDirector}' : 'Director: ${rec.authorOrDirector}',
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
}
