// lib/services/sale_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:butik/models/sale.dart';

class SaleService {
  final String apiUrl = 'https://api.kartel.dev';

  Future<List<Sale>> getSales() async {
    final response = await http.get(Uri.parse('$apiUrl/sales'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sale) => Sale.fromJson(sale)).toList();
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<void> addSale(Sale sale) async {
    final response = await http.post(
      Uri.parse('$apiUrl/sales'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'buyer': sale.buyer,
        'phone': sale.phone,
        'date': sale.date,
        'status': sale.status,
        'issuer': sale.issuer,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add sale');
    }
  }

  Future<void> updateSale(Sale sale) async {
    final response = await http.put(
      Uri.parse('$apiUrl/sales/${sale.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'buyer': sale.buyer,
        'phone': sale.phone,
        'date': sale.date,
        'status': sale.status,
        'issuer': sale.issuer,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sale');
    }
  }
}
