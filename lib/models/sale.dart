// lib/models/sale.dart
class Sale {
  final String id;
  final String buyer;
  final String phone;
  final String date;
  final String status;
  final String issuer;

  Sale({
    required this.id,
    required this.buyer,
    required this.phone,
    required this.date,
    required this.status,
    required this.issuer,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      buyer: json['buyer'],
      phone: json['phone'],
      date: json['date'],
      status: json['status'],
      issuer: json['issuer'],
    );
  }
}
