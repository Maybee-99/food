import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food/widget/widget_reuse.dart';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

class api_service {
  final String url = "http://192.168.104.99:3000/";
  final String server_url =
      "https://api.cloudinary.com/v1_1/dreyxbtxj/image/upload";

  Future<List<dynamic>> getCategories(BuildContext context) async {
    try {
      var response = await http.get(Uri.parse(url + "categories"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
        return [];
      }
    } catch (e) {
      showAlert(context, "ຂໍ້ຄວາມ", "ເກີດຂໍ້ຜິດພາດ${e}", "ຕົກລົງ");
      return [];
    }
  }

  Future<Map<String, dynamic>?> createCategory(
    BuildContext context,
    String category,
  ) async {
    var response = await http.post(
      Uri.parse(url + "categories"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"category_name": category}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      showAlert(context, "ຂໍ້ຄວາມ", "ຂໍ້ມູນຊ້ຳກັນ", "ຕົກລົງ");
      return null;
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateCategory(
    BuildContext context,
    String category,
    String id,
  ) async {
    var response = await http.put(
      Uri.parse(url + "categories/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"category_name": category}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteCategory(
    BuildContext context,
    String id,
  ) async {
    var response = await http.delete(
      Uri.parse(url + "categories/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }

  Future<List<dynamic>> getUnit(BuildContext context) async {
    var response = await http.get(Uri.parse(url + "unit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return [];
    }
  }

  Future<Map<String, dynamic>?> createUnit(
    BuildContext context,
    String category,
  ) async {
    var response = await http.post(
      Uri.parse(url + "unit"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"unit_name": category}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      showAlert(context, "ຂໍ້ຄວາມ", "ຂໍ້ມູນຊ້ຳກັນ", "ຕົກລົງ");
      return null;
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateUnit(
    BuildContext context,
    String category,
    String id,
  ) async {
    var response = await http.put(
      Uri.parse(url + "unit/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"unit_name": category}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteUnit(
    BuildContext context,
    String id,
  ) async {
    var response = await http.delete(
      Uri.parse(url + "unit/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }

  Future<List<dynamic>> getProducts(BuildContext context) async {
    var response = await http.get(Uri.parse(url + "products"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return [];
    }
  }

  Future<List<dynamic>> getProductsWithCate(
    BuildContext context,
    String category,
  ) async {
    var response = await http.get(Uri.parse(url + "products/$category"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return [];
    }
  }

  Future<Map<String, dynamic>?> createProduct(
    BuildContext context,
    String name,
    String price,
    String quantity,
    String category,
    String unit,
    String image,
  ) async {
    var response = await http.post(
      Uri.parse(url + "products"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "product_name": name,
        "price": price,
        "stock": quantity,
        "category_id": category,
        "unit_id": unit,
        "image_url": image,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      showAlert(context, "ຂໍ້ຄວາມ", "ຂໍ້ມູນຊ້ຳກັນ", "ຕົກລົງ");
      return null;
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ເກີດຂໍ້ຜິດພາດ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProduct(
    BuildContext context,
    String name,
    String price,
    String quantity,
    String category,
    String unit,
    String id,
  ) async {
    var response = await http.put(
      Uri.parse(url + "products/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "product_name": name,
        "price": price,
        "stock": quantity,
        "category_id": category,
        "unit_id": unit,
        "product_id": id,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ເກີດຂໍ້ຜິດພາດ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteProduct(
    BuildContext context,
    String id,
  ) async {
    var response = await http.delete(
      Uri.parse(url + "products/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ເກີດຂໍ້ຜິດພາດ", "ຕົກລົງ");
      return null;
    }
  }

  Future<String> upLoadImageToCloud(File image, BuildContext context) async {
    final uri = Uri.parse(server_url);
    final preset = "flutter-upload";
    try {
      final request =
          http.MultipartRequest('POST', uri)
            ..fields['upload_preset'] = preset
            ..files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final resData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(resData);
        return jsonResponse["secure_url"];
      } else {
        final resData = await response.stream.bytesToString();
        showAlert(context, "ຂໍ້ຄວາມ", "${resData}", "ຕົກລົງ");
      }
    } catch (e) {
      showAlert(context, "ຂໍ້ຄວາມ", "${e}", "ຕົກລົງ");
    }
    return "";
  }
}
