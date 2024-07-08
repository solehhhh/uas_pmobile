// lib/screens/sales_screen.dart
import 'package:flutter/material.dart';
import 'package:butik/models/sale.dart';
import 'package:butik/services/sale_service.dart';
import 'package:butik/screens/sales_form_screen.dart';

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  SaleService saleService = SaleService();
  late Future<List<Sale>> futureSales;

  @override
  void initState() {
    super.initState();
    futureSales = saleService.getSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sales')),
      body: FutureBuilder<List<Sale>>(
        future: futureSales,
        builder: (context, snapshot) {
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
                Sale sale = snapshot.data![index];
                return ListTile(
                  title: Text(sale.buyer),
                  subtitle: Text('Status: ${sale.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SalesFormScreen(
                                saleService: saleService,
                                sale: sale,
                              ),
                            ),
                          ).then((_) {
                            setState(() {
                              futureSales = saleService.getSales();
                            });
                          });
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
            MaterialPageRoute(
              builder: (context) => SalesFormScreen(saleService: saleService),
            ),
          ).then((_) {
            setState(() {
              futureSales = saleService.getSales();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
