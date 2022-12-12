import 'dart:developer';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:movie_app/models/movie.dart';

class Payment {
  static const apiKey = "";
  static const publicKey = "";
  static const businessId = "";

  static Map<String, String> headers = {
    "accept": "application/json",
    "api-key": apiKey,
    "x-pub-key": publicKey,
    "x-business-id": businessId,
  };

  static final dio = Dio()
    ..options.baseUrl = 'https://sandboxapi.fincra.com/checkout/payments'
    ..options.headers = headers;

  /// Get Checkout Link
  static Future<Map> getCheckoutLink(
      {required String name,
      required String email,
      required Movie movie}) async {
    //
    Map<String, dynamic> body = {
      "customer": {"name": name, "email": email},
      "amount": movie.price,
      "currency": "NGN",
      "reference": _generateID(movie.id)
    };

    final response = await dio.post('', data: body);

    final data = response.data['data'];
    print(data);

    return data;
  }

  static Future<Map> verifyPayment(String reference) async {
    final response = await dio.get('/merchant-reference/$reference');

    final data = response.data['data'];
    inspect(data);

    return data;
  }

  static String _generateID(String movieId) {
    Random rnd = Random();

    return 'movie-$movieId-${(rnd.nextInt(4294967296) + 1000000000).toString()}${DateTime.now().millisecondsSinceEpoch}';
  }
}
