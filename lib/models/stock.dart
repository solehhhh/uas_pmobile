// lib/models/stock.dart
class Stock {
  final String id;
  final String name;
  final int qty;
  final String attr;
  final int weight;
  final int createdAt;
  final int updatedAt;
  final String issuer;

  Stock({
    required this.id,
    required this.name,
    required this.qty,
    required this.attr,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
    required this.issuer,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      name: json['name'],
      qty: json['qty'],
      attr: json['attr'],
      weight: json['weight'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      issuer: json['issuer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'attr': attr,
      'weight': weight,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'issuer': issuer,
    };
  }
}
