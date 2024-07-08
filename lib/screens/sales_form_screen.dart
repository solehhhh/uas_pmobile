// lib/screens/sales_form_screen.dart
import 'package:flutter/material.dart';
import 'package:butik/models/sale.dart';
import 'package:butik/services/sale_service.dart';

class SalesFormScreen extends StatefulWidget {
  final SaleService saleService;
  final Sale? sale;

  const SalesFormScreen({Key? key, required this.saleService, this.sale}) : super(key: key);

  @override
  _SalesFormScreenState createState() => _SalesFormScreenState();
}

class _SalesFormScreenState extends State<SalesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _buyerController;
  late TextEditingController _phoneController;
  late TextEditingController _dateController;
  late TextEditingController _statusController;
  late TextEditingController _issuerController;

  @override
  void initState() {
    super.initState();
    _buyerController = TextEditingController(text: widget.sale?.buyer ?? '');
    _phoneController = TextEditingController(text: widget.sale?.phone ?? '');
    _dateController = TextEditingController(text: widget.sale?.date ?? '');
    _statusController = TextEditingController(text: widget.sale?.status ?? '');
    _issuerController = TextEditingController(text: widget.sale?.issuer ?? '');
  }

  @override
  void dispose() {
    _buyerController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _statusController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.sale == null) {
        // Add sale
        widget.saleService.addSale(Sale(
          id: DateTime.now().toString(),
          buyer: _buyerController.text,
          phone: _phoneController.text,
          date: _dateController.text,
          status: _statusController.text,
          issuer: _issuerController.text,
        )).then((_) {
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add sale: $error')));
        });
      } else {
        // Update sale
        widget.saleService.updateSale(Sale(
          id: widget.sale!.id,
          buyer: _buyerController.text,
          phone: _phoneController.text,
          date: _dateController.text,
          status: _statusController.text,
          issuer: _issuerController.text,
        )).then((_) {
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update sale: $error')));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.sale == null ? 'Add Sale' : 'Edit Sale')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _buyerController,
                decoration: const InputDecoration(labelText: 'Buyer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a buyer';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a status';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _issuerController,
                decoration: const InputDecoration(labelText: 'Issuer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an issuer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.sale == null ? 'Add Sale' : 'Update Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
