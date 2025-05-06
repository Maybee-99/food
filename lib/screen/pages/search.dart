import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food/service/productService.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final api = ProductService();
  bool isLoading = true;
  List<dynamic> product = [];
  List<dynamic> productSearch = [];
  TextEditingController searchControler = TextEditingController();
  @override
  void initState() {
    loadProduct();
    super.initState();
    searchControler.addListener(() {
      setState(() {});
    });
  }

  void loadProduct() async {
    final data = await api.getProducts(context);
    setState(() {
      product = data;
      productSearch.clear();
      isLoading = false;
    });
  }

  void searchProduct(String value) async {
    if (value.isEmpty) {
      loadProduct();
      setState(() {
        productSearch.clear();
      });
      return;
    }
    final data = await api.search(context, value);
    setState(() {
      productSearch = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 45,
          child: TextField(
            controller: searchControler,
            onChanged: (val) {
              searchProduct(val);
            },
            decoration: InputDecoration(
              hintText: "ຄົ້ນຫາ",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              prefixIcon: Icon(Icons.search, size: 25, color: Colors.green),
              suffixIcon:
                  searchControler.text.isEmpty
                      ? null
                      : IconButton(
                        onPressed: () {
                          searchControler.clear();
                          searchProduct("");
                        },
                        icon: Icon(Icons.clear, color: Colors.green, size: 25),
                      ),
              focusedBorder: (OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: const Color.fromARGB(26, 35, 34, 34),
                  width: 1.0,
                ),
              )),
              enabledBorder: (OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: const Color.fromARGB(26, 35, 34, 34),
                  width: 1.0,
                ),
              )),
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5.0),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "ສິນຄ້າທັງໝົດ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Center(
                child:
                    isLoading
                        ? CircularProgressIndicator(color: Colors.green)
                        : (searchControler.text.isEmpty
                            ? (product.isEmpty)
                                ? Text("ບໍ່ມີສິນຄ້າ")
                                : buildGrid(product)
                            : (productSearch.isEmpty
                                ? Text("ບໍ່ພົບສິນຄ້ານີ້")
                                : buildGrid(productSearch))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(List<dynamic> data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Card(
            color: Colors.white,
            elevation: 2,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: data[index]['image_url'] ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 120,
                    errorWidget:
                        (context, url, error) =>
                            Icon(Icons.image, color: Colors.green, size: 50),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      data[index]['product_name'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      data[index]['price'].toString() +
                          "₭/" +
                          data[index]['unit_name'],
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
