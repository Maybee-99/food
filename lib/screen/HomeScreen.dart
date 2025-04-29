import 'package:flutter/material.dart';
import 'package:food/screen/pages/Home.dart';
import 'package:food/screen/pages/search.dart';
import 'package:food/screen/pages/service.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List pages = [Home(), Cart(), Search()];

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  void onTap(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          pages.isEmpty
              ? Center(child: CircularProgressIndicator())
              : pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'ໜ້າຫຼັກ'),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'ກະຕ່າ',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'ຄົ້ນຫາ'),
        ],
        currentIndex: _index,
        onTap: onTap,
      ),
    );
  }
}
