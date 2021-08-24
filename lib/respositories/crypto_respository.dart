import 'dart:convert';

import 'package:crypto_price/models/coin_model.dart';
import 'package:crypto_price/models/failure_model.dart';
import 'package:http/http.dart' as http;

class CryptoRespository {
  static const String _baseurl = "https://min-api.cryptocompare.com/";
  static const int perpage = 20;

  final http.Client _httpClient;
  CryptoRespository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<List<Coin>> getTopCoin({required int page}) async {
    final requestUrl =
        '${_baseurl}data/top/totalvolfull?limit=${perpage.toString()}&tsym=USD&page=${page.toString()}';
    try {
      final response = await _httpClient.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        final Coinlist = List.from(data["Data"]);

        return Coinlist.map((e) => Coin.fromMap(e)).toList();
      }

      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
