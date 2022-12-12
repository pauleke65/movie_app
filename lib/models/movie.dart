class Movie {
  final String id;
  final String name;
  final String genre;
  final String duration;
  final String ratings;
  final String releaseDate;
  final String synopsis;
  final String imageUrl;
  final String trailerLink;
  final String price;

  Movie({
    required this.id,
    required this.name,
    required this.genre,
    required this.duration,
    required this.ratings,
    required this.releaseDate,
    required this.synopsis,
    required this.imageUrl,
    required this.trailerLink,
    required this.price,
  });

  factory Movie.fromDocList(List<String> row) {
    return Movie(
        id: row[0],
        name: row[1],
        genre: row[2],
        duration: row[3],
        ratings: row[4],
        releaseDate: row[5],
        synopsis: row[6],
        imageUrl: row[7],
        trailerLink: row[8],
        price: row[9]);
  }
}
