// lib/screens/stock_screen.dart
import 'package:flutter/material.dart';
import 'package:butik/models/stock.dart';
import 'package:butik/screens/stock_form_screen.dart';
import 'package:butik/services/stock_service.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  StockService stockService = StockService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stocks')),
      body: FutureBuilder<List<Stock>?>(
        future: stockService.getStocks(),
        builder: (context, AsyncSnapshot<List<Stock>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Stock stock = snapshot.data![index];
                return ListTile(
                  title: Text('Name: ${stock.name.isNotEmpty ? stock.name : "Unknown"}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${stock.qty}'),
                      Text('Attribute: ${stock.attr}'),
                      Text('Weight: ${stock.weight}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StockFormScreen(stock: stock, stockService: stockService),
                            ),
                          ).then((_) {
                            setState(() {}); // Refresh UI after returning from StockFormScreen
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteStock(stock.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StockFormScreen(stockService: stockService)),
          ).then((_) {
            setState(() {}); // Refresh UI after returning from StockFormScreen
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteStock(String id) {
    stockService.deleteStock(id).then((_) {
      setState(() {}); // Refresh UI after deletion
    });
  }
}
