import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/google_sheet.dart';

import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    loadMovie();
    super.initState();
  }

  void loadMovie() async {
    movies = await SheetsAPI.getMovies();
    setState(() {
      _currImage = movies[0].imageUrl;
    });
  }

  String? _currImage;

  List<Movie> movies = [];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: movies.isEmpty
          ? const CircularProgressIndicator()
          : Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: _currImage == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              scale: 0.1,
                              image: NetworkImage(_currImage!)),
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(10)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  ),
                ),
                Center(
                  child: CarouselSlider.builder(
                    itemCount: movies.length,
                    itemBuilder: ((context, index, realIndex) {
                      final movie = movies[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 2 / 3.5,
                            child: Hero(
                              tag: movie.id,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) =>
                                              DetailsScreen(movie: movie)));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenSize.width * 0.03),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade600,
                                            spreadRadius: 1,
                                            blurRadius: 15)
                                      ],
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(movie.imageUrl)),
                                      color: Colors.white30,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.04),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              movie.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      );
                    }),
                    options: CarouselOptions(
                        aspectRatio: 1 / 2,
                        viewportFraction: 0.85,
                        clipBehavior: Clip.none,
                        onPageChanged: (_, __) {
                          setState(() {
                            _currImage = movies[_].imageUrl;
                          });
                        }),
                  ),
                ),
              ],
            ),
    ));
  }
}
