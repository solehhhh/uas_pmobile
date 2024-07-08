// lib/screens/stock_form_screen.dart
import 'package:flutter/material.dart';
import 'package:butik/models/stock.dart';
import 'package:butik/services/stock_service.dart';

class StockFormScreen extends StatefulWidget {
  final Stock? stock;
  final StockService stockService;

  StockFormScreen({this.stock, required this.stockService});

  @override
  _StockFormScreenState createState() => _StockFormScreenState();
}

class _StockFormScreenState extends State<StockFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _qtyController;
  late TextEditingController _attrController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.stock?.name ?? '');
    _qtyController = TextEditingController(text: widget.stock?.qty.toString() ?? '0');
    _attrController = TextEditingController(text: widget.stock?.attr ?? '');
    _weightController = TextEditingController(text: widget.stock?.weight.toString() ?? '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _attrController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveStock() {
    if (_formKey.currentState!.validate()) {
      final stock = Stock(
        id: widget.stock?.id ?? '', // Use empty string if stock is null
        name: _nameController.text,
        qty: int.parse(_qtyController.text),
        attr: _attrController.text,
        weight: int.parse(_weightController.text),
        createdAt: widget.stock?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        issuer: 'admin', // Replace with actual issuer if available
      );

      if (widget.stock == null) {
        // Add new stock
        widget.stockService.createStock(stock).then((_) => Navigator.pop(context));
      } else {
        // Update existing stock
        widget.stockService.updateStock(stock).then((_) => Navigator.pop(context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.stock == null ? 'Add Stock' : 'Edit Stock')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _qtyController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _attrController,
                decoration: InputDecoration(labelText: 'Attribute'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter attribute';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveStock,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
