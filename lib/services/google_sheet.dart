import 'package:gsheets/gsheets.dart';
import 'package:movie_app/models/movie.dart';

class SheetsAPI {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "movie-app-370719",
  "private_key_id": "f051c8d51ba7ada4810f75b9447daa8e8c71107d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCZfMNBdEttomwj\nY2DVXY3CMWmAGTx/ublrLm8PlMBhURFmBE7ZnO1pXKvP+FPExYHZou3AeutPVDKz\nci6+qlXTYZ0iOxbIq+VOyG0f6N0sSjCQIPk3lgc8JHpV3TJUTB5DSUEi0AzaXVTk\nr1tpl01yoeiW3OD48+NTCW0+8UnM+LWQ8Oot0bXI6LS7TN0xbkqtU2k7nODB3FpJ\n1IsJk5E+6EIql8otu/qfixUOy0tf3rgXEGoZWSNoZZeStKzjl5pPAb1qalsnuGl8\nhIYE+UUfV0UTwMLemWL55wrSCw51JI3E5FDpDue71k0Ru4tg4SvUf6VhJcp1XFYh\nmlObKryzAgMBAAECggEAOXp56oShDJ0DLxtzs2N2B0+WySRqPhCwqb05VRXpF2iT\nAefCGYdFdyv/oYHG6QznzDdSHr9JaKtI01+Ctt82BdNr01padWq+FEtFZmo/jWr5\nFbhra9AQxIqKj6Ymx1+8A4mmzWEpNws1k/BBZOEG3VNZtUlhLIm0yy9gDG6yqwGx\njbWdUtgwQYM07x6jZlAvv3fh6nRyllJxzwy2LEe4KpMjb3GYP9Lr7MYD/UIbUKmL\nGiOYRQixma0KY/MakDJJWY0DxYY4Ftcrjf7ZRzxDlYkhtLD1fzgfNwdrcGCKTfkM\n/4DbVWnWS2kavRKo+Yhr9MKzSAGsEGntGZkMW975RQKBgQDXc4aBDd0XoUjUY3Tg\nmHDwj4xI+8R5MrVC9lc1ROdH3/6LnvTibwYAmu5xDDDJKgCPgtXBQRhvGe1CbH8P\nBRay4vM4Q3z8EL8TnVDaicor/NFUy4+OjpfcYgFTPnWzBiwj2B80stV/dDp5Q66u\nd2IwduBZk3Oqaa+xsxiAgtZqrQKBgQC2X852nhtGCwH9Y8af0hO1wVfbECLJZz5p\nyEdeV6/gGWSkFPlqwKTctzMefJzUKGnXSLUdJymr6TigEwxHaN2WTtoF+RwTFaAs\nXvHWcfPDk94/yb347s9KkozTTyLcU+oGUIhPbgsY5eoBWs5ARPyEiQCvAm38FDpR\n1Z6+or0Q3wKBgQCTf8iuo5Igck+M8AX9GQABARV2hb6thrSngkST+HcqMsRuS8W1\nG3MNiQQCqujfX30Awv6aDnmu3h4bYnHeE4rFry/57eIsIz7dK89Fvh2F3dBl7/J5\nE1AOFZ54ogMsK+aeJ4C9sE0Ps7+wc1CsqpizOz8+s/70xOP+kPEOUgR/BQKBgDQJ\nqlPWUVnvEiZHLgm0W8Nk47iyJfrp5rkwWIzm4FxFYp4fDfwT8/a2n3N3gxhWX7z6\nFhO3dQCEj4+9X6eQmImm/jbuGcCoTwfaH49c/H012BjDa9135tYUcvJohj3wA7rB\nh+OCNtBn6hlw26EjDhqTLQrC2rcu3mUzWxRyQxhpAoGBAMZPUXJz+zwFG03rf4m6\n2SNlMW0cLsv9bx0kLZ/rClchHYUrTZkOGyIJshXbTOWbI1xEkwjYbVVKbsVXyR6K\nARBBkdV5/vbIDYMpcwy4k0/gU4mxHiVVZkJtZ/PNFSs51mbsAJ9XwSDVi2x/iOVZ\nIsRJCqpNyQ3oMbk2M2kOpx3j\n-----END PRIVATE KEY-----\n",
  "client_email": "google-sheets@movie-app-370719.iam.gserviceaccount.com",
  "client_id": "110246324879278260578",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/google-sheets%40movie-app-370719.iam.gserviceaccount.com"
}
''';

  static const _spreadsheetId = '1gzCSczMfb1s8sXy81unXs3vR3JMBwFVTdJxDxk19ScI';

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
