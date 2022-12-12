import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/ui/screens/form_screen.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: screenSize.width * 0.7,
                child: Row(
                  children: [
                    Hero(
                      tag: movie.id,
                      child: Container(
                        width: screenSize.width * 0.5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(movie.imageUrl)),
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GenreItem('Genre:', movie.genre),
                        GenreItem('Duration:', movie.duration),
                        GenreItem('Ratings:', '${movie.ratings}/10'),
                        GenreItem('Release Date:', movie.releaseDate),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Synopsis',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                movie.synopsis,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              const Text(
                'Ticket Price',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                'NGN ${movie.price}',
                style: TextStyle(
                  fontSize: screenSize.height * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => FormScreen(movie: movie)));
                },
                minWidth: double.infinity,
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Colors.red,
                child: const Text(
                  "Book Movie Seat",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class GenreItem extends StatelessWidget {
  const GenreItem(
    this.categoryName,
    this.categoryDetail, {
    Key? key,
  }) : super(key: key);

  final String categoryName;
  final String categoryDetail;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          categoryDetail,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
