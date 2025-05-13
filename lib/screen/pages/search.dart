import 'package:flutter/material.dart';
import 'package:food/service/categoryService.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final api = CategoryService();
  bool isLoading = true;
  bool isSearching = false;

  List<dynamic> product = [];
  List<dynamic> productSearch = [];
  TextEditingController searchControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProduct();
    searchControler.addListener(() {
      final query = searchControler.text.trim();
      if (query.isNotEmpty) {
        filterSearch(query);
      } else {
        setState(() {
          productSearch.clear();
        });
      }
    });
  }

  void loadProduct() async {
    final data = await api.getCategories(context);
    setState(() {
      product = data;
      productSearch.clear();
      isLoading = false;
    });
  }

  void filterSearch(String query) {
    final result =
        product.where((item) {
          final name = item['category_name'].toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();

    setState(() {
      productSearch = result;
    });
  }

  void clearSearch() {
    searchControler.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      isSearching = false;
      productSearch.clear();
    });
  }

  @override
  void dispose() {
    searchControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading:
            isSearching
                ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: clearSearch,
                )
                : null,
        title: TextField(
          controller: searchControler,
          onTap: () {
            setState(() {
              isSearching = true;
            });
          },
          decoration: InputDecoration(
            hintText: "ຄົ້ນຫາ",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            prefixIcon: const Icon(Icons.search, color: Colors.green),
            suffixIcon:
                searchControler.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.green),
                      onPressed: () {
                        searchControler.clear();
                      },
                    )
                    : null,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
          ),
        ),
      ),
      body: isSearching ? buildSearchBody() : buildDefaultBody(),
    );
  }

  Widget buildDefaultBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle("ສິນຄ້າທັງໝົດ"),
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
              : product.isEmpty
              ? const Center(child: Text("ບໍ່ມີສິນຄ້າ"))
              : buildGrid(product),
          sectionTitle("ສິນຄ້ານິຍົມ"),
          // You can add popular items here later
        ],
      ),
    );
  }

  Widget buildSearchBody() {
    return productSearch.isEmpty
        ? const Center(child: Text("ບໍ່ພົບສິນຄ້ານີ້"))
        : buildGrid(productSearch);
  }

  Widget buildGrid(List<dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  data[index]['category_name'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
