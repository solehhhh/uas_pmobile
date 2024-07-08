// lib/services/stock_service.dart
import 'package:butik/models/stock.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService {
  final String apiUrl = 'https://api.kartel.dev/stocks';

  Future<List<Stock>> getStocks() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((stock) => Stock.fromJson(stock)).toList();
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  Future<void> deleteStock(String id) async {
    final url = Uri.parse('$apiUrl/$id');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete stock');
    }
  }

  Future<void> createStock(Stock stock) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(stock.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create stock');
    }
  }

  Future<void> updateStock(Stock stock) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${stock.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(stock.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update stock');
    }
  }
}
