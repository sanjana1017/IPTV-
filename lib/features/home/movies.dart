import 'package:flutter/material.dart';

class MoviesPage extends StatelessWidget {
  // List of sample movies
  final List<Movie> movies = [
    Movie(
        title: 'Inception', 
        imageUrl: 'https://via.placeholder.com/150',
        genre: 'Sci-Fi'),
    Movie(
        title: 'Interstellar',
        imageUrl: 'https://via.placeholder.com/150',
        genre: 'Adventure'),
    Movie(
        title: 'The Dark Knight',
        imageUrl: 'https://via.placeholder.com/150',
        genre: 'Action'),
    Movie(
        title: 'Fight Club',
        imageUrl: 'https://via.placeholder.com/150',
        genre: 'Drama'),
    Movie(
        title: 'Pulp Fiction',
        imageUrl: 'https://via.placeholder.com/150',
        genre: 'Crime'),
    Movie(
        title: 'The Matrix',
        imageUrl: 'https://via.placeholder.com/150',
        genre: 'Sci-Fi'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Display 2 items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7, // Control the ratio between width and height
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(movie: movie); // Build individual movie cards
          },
        ),
      ),
      backgroundColor: Colors.black, // Match the background color
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850], // Dark background for the movie card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              child: Image.network(
                movie.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover, // Ensures the image covers the container
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Adds "..." if the text overflows
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              movie.genre,
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }
}

class Movie {
  final String title;
  final String imageUrl;
  final String genre;

  Movie({required this.title, required this.imageUrl, required this.genre});
}
