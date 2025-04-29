import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food/service/constant.dart';
import 'package:food/widget/widget_reuse.dart';
import 'package:http/http.dart' as http;

class SearchService {
  Future<List<dynamic>> search(BuildContext context, String parameter) async {
    try {
      final encodedName = Uri.encodeComponent(parameter);
      final response = await http.get(Uri.parse(url + "search/$encodedName"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      showAlert(context, "ຂໍ້ຄວາມ", "ເກີດຂໍ້ຜິດພາດ", "ຕົກລົງ");
      return [];
    }
  }
}
