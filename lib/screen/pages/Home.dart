import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food/controller/category.dart';
import 'package:food/controller/product.dart';
import 'package:food/controller/unit.dart';
import 'package:food/service/api_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final api = api_service();
  bool _isLoading = true;
  List<dynamic> _categories = [];
  List<dynamic> _products = [];
  @override
  void initState() {
    loadCategorise();
    loadProducts();
    super.initState();
  }

  void loadCategorise() async {
    final categories = await api.getCategories(context);
    setState(() {
      _categories = [
        {"category_name": "ທັງໝົດ"},
        ...categories,
      ];
      _isLoading = false;
    });
  }

  void loadProducts() async {
    final products = await api.getProducts(context);
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  void loadProductsWithCategory(int index) async {
    setState(() {
      _isLoading = true;
    });
    final products = await api.getProductsWithCate(
      context,
      _categories[index]['category_name'],
    );
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.blueGrey),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.green),
              child: Center(
                child: Text(
                  "ແອັບຂາຍສິນຄ້າອອນລາຍ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(
                "ຈັດການສິນຄ້າ",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Products()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text(
                "ຈັດການຫົວໜ່ວຍ",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Unit()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text(
                "ຈັດການໝວດໝູ່",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Category()),
                );
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.green,
              child: Center(
                child: Text(
                  "ແບນເນີ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "ໝວດໝູ່",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            category(),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "ສິນຄ້າ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            product(),
          ],
        ),
      ),
    );
  }

  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget category() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            bool isAll = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                onItemTapped(index);
                if (index == 0) {
                  loadProducts();
                } else {
                  loadProductsWithCategory(index);
                }
              },
              child: Container(
                width: 100,
                child: Card(
                  elevation: 3,

                  color: isAll ? Colors.green : Colors.white,
                  child: Center(
                    child: Text(
                      _categories[index]['category_name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isAll ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget product() {
    if (_products.isEmpty) {
      return Center(child: CircularProgressIndicator(color: Colors.green));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GridView.builder(
        physics: PageScrollPhysics(),
        shrinkWrap: true,
        itemCount: _products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: _products[index]['image_url'] ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: 90,
                    errorWidget:
                        (context, url, error) =>
                            Icon(Icons.image, size: 50, color: Colors.green),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      _products[index]['product_name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${_products[index]['price']} ₭/ ${_products[index]['unit_name']}",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
