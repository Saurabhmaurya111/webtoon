import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, String> category;

  DetailScreen({required this.category});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  


  bool isFavorite = false;
  double currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    _loadRating(); 
  }

  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.category['title']!) ?? false;
    });
  }

 
  Future<void> _loadRating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentRating = prefs.getDouble('${widget.category['title']}_rating') ?? 0.0;
    });
  }


  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
    });
    prefs.setBool(widget.category['title']!, isFavorite);
    print('Favorite status for ${widget.category['title']} saved: $isFavorite');
  }

 
  Future<void> _setRating(double rating) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentRating = rating;
    });
    prefs.setDouble('${widget.category['title']}_rating', rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category['title']!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(widget.category['thumbnail']!),
              SizedBox(height: 16),
              Text(
                widget.category['title']!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(widget.category['description']!),
              SizedBox(height: 16),
              Row(
                children: [
                 ElevatedButton(
  onPressed: _toggleFavorite,
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), 
    backgroundColor: isFavorite ? Colors.red : Colors.green,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30), 
    ),
    elevation: 5, 
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  child: Text(
    isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
    style: TextStyle(color: Colors.white), 
  ),
),
                  Spacer(),
                  Text('Rating: ${currentRating.toStringAsFixed(1)}'),
                ],
              ),
              SizedBox(height: 16),
              _buildRatingBar(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildRatingBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            _setRating(index + 1.0);
          },
        );
      }),
    );
  }
}
