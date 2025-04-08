import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/service/api_service.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final api = api_service();
  bool _isLoading = true;
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final products = await api.getProducts(context);
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  void deleteProduct(int index) async {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("ລຶບສິນຄ້າ", style: TextStyle(fontSize: 16)),
          content: Text(
            "ທ່ານແນ່ໃຈຈະລຶບແທ້ບໍ່?",
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ຍົກເລີກ", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                api
                    .deleteProduct(
                      context,
                      _products[index]['product_id'].toString(),
                    )
                    .then((value) {
                      if (value != null) {
                        setState(() {
                          _products.removeAt(index);
                        });
                        loadProducts();
                      }
                    });
                Navigator.pop(context);
              },
              child: Text("ຕົກລົງ", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ຈັດການສິນຄ້າ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _products.isEmpty
              ? Center(child: Text("ບໍ່ມີຂໍ້ມູນ"))
              : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['product_name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${product['price']} ₭",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          // Action buttons
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_document,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // Navigate to edit product screen
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteProduct(index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
