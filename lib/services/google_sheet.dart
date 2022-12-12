import 'package:gsheets/gsheets.dart';
import 'package:movie_app/models/movie.dart';

class SheetsAPI {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "",
  "private_key_id": "",
  "private_key": "",
  "client_email": "",
  "client_id": "",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": ""
}
''';

  static const _spreadsheetId = '';

  static late Spreadsheet spreadsheet;

  static Future<void> init() async {
    // init GSheets
    final gsheets = GSheets(_credentials);
    // fetch spreadsheet by its id

    spreadsheet = await gsheets.spreadsheet(_spreadsheetId);
  }

  static Future<List<Movie>> getMovies() async {
    await init();
    final sheet = spreadsheet.worksheetByTitle('Movies');
    List<Movie> movies = [];
    final list = await sheet!.values.allRows();

    list.removeAt(0);

    for (List<String> item in list) {
      movies.add(Movie.fromDocList(item));
    }

    return movies;
  }

  static Future<bool> updateBoughtTicket({
    required String email,
    required String fullName,
    required String movieName,
    required String paymentDate,
    required String status,
    required String merchantReference,
    required String paymentReference,
    required String amount,
  }) async {
    final paysheet = spreadsheet.worksheetByTitle('Payments');
    return await paysheet!.values.appendRow([
      email,
      fullName,
      movieName,
      paymentDate,
      status,
      merchantReference,
      paymentReference,
      amount,
    ]);
  }
}
