// lib/screens/product_screen.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:butik/models/product.dart';
import 'package:butik/services/product_service.dart';
import 'package:butik/screens/product_form_screen.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductService productService = ProductService();
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = productService.getProducts();
  }

  void _showImageDialog(String productId) async {
    Uint8List? imageData = await productService.getProductImage(productId);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: imageData != null
              ? Image.memory(imageData)
              : Text('No image available'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
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
                Product product = snapshot.data![index];
                return ListTile(
                  title: Text(product.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductFormScreen(
                                productService: productService,
                                product: product,
                              ),
                            ),
                          ).then((_) {
                            setState(() {
                              futureProducts = productService.getProducts();
                            });
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {
                          _showImageDialog(product.id);
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
              builder: (context) => ProductFormScreen(productService: productService),
            ),
          ).then((_) {
            setState(() {
              futureProducts = productService.getProducts();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
