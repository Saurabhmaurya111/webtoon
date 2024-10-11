import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favoriteTitles = [];
  Map<String, double> ratings = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites(); 
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> allKeys = prefs.getKeys().toList();
    List<String> favs = [];
    Map<String, double> loadedRatings = {};

    for (String key in allKeys) {
      if (!key.endsWith('_rating')) {
        bool? isFavorite = prefs.getBool(key);
        if (isFavorite == true) {
          favs.add(key);
      
          double? rating = prefs.getDouble('${key}_rating');
          if (rating != null) {
            loadedRatings[key] = rating;
          }
        }
      }
    }

  
    setState(() {
      favoriteTitles = favs;
      ratings = loadedRatings;
    });
  }


  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor:  Colors.teal.shade50,
      ),
      body: favoriteTitles.isEmpty
          ? Center(
              child: Text(
                'No favorites added',
                style: TextStyle(fontSize: 18, color:  Colors.teal.shade50),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: favoriteTitles.length,
              itemBuilder: (context, index) {
                String title = favoriteTitles[index];
                double rating = ratings[title] ?? 0.0;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                      
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.bookmark,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 16),

                       
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              _buildStarRating(rating), 
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
