// import 'dart:developer';
import 'package:flutter_vs_code/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider extends ChangeNotifier {
  //DEFINISIKAN PRIVATE VARIABLE DENGAN TYPE List dan VALUENYA MENGGUNAKAN FORMAT EMPLOYEEMODEL
  //DEFAULTNYA KITA BUAT KOSONG
  List<ProductModel> _data = [];
  //KARENA PRIVATE VARIABLE TIDAK BISA DIAKSES OLEH CLASS/FILE LAINNYA, MAKA DIPERLUKAN GETTER YANG BISA DIAKSES SECARA PUBLIC, ADAPUN VALUENYA DIAMBIL DARI _DATA
  List<ProductModel> get dataProduct => _data;

  //BUAT FUNGSI UNTUK MELAKUKAN REQUEST DATA KE SERVER / API
  Future<List<ProductModel>> getProduct() async {
    // final url = 'http://employee-crud-flutter.daengweb.id/index.php';
    final url = 'https://60614ba7ac47190017a709e8.mockapi.io/api/products';
    
    final response = await http.get(url); //LAKUKAN REQUEST DATA

    //JIKA STATUSNYA BERHASIL ATAU = 200
    if (response.statusCode == 200) {
      //MAKA KITA FORMAT DATANYA MENJADI MAP DENGNA KEY STRING DAN VALUE DYNAMIC
      // final result = json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      final result = json.decode(response.body).cast<Map<String, dynamic>>();
      //KEMUDIAN MAPPING DATANYA UNTUK KEMUDIAN DIUBAH FORMATNYA SESUAI DENGAN EMPLOYEEMODEL DAN DIPASSING KE DALAM VARIABLE _DATA
      _data = result.map<ProductModel>((json) => ProductModel.fromJson(json)).toList();
      return _data;
    } else {
      throw Exception();
    }
  }

  Future<ProductModel> findProduct(String id) async {
    return _data.firstWhere((i) => i.id == id); //JADI KITA CARI DATA BERDASARKAN ID DAN DATA PERTAMA AKAN DISELECT
  }

  Future<bool> storeProduct(String name, String purchase, String selling, String qty) async {
    final url = 'https://60614ba7ac47190017a709e8.mockapi.io/api/products';
    //KIRIM REQUEST KE SERVER DENGAN MENGIRIMKAN DATA YANG AKAN DITAMBAHKAN PADA BODY
    final response = await http.post(url, body: {
      'product_name': name,
      'product_purchase': purchase,
      'product_selling': selling,
      'product_qty': qty,
    });

    //DECODE RESPONSE YANG DITERIMA
    // final result = json.decode(response.body);
    //LAKUKAN PENGECEKAN, JIKA STATUS CODENYA 200 DAN STATUS SUCCESS
    if (response.statusCode == 201) { //&& result['status'] == 'success'
      notifyListeners(); //MAKA INFORMASIKAN PADA LISTENERS BAHWA ADA DATA BARU
      return true;
    }
    return false;
  }

  //JADI KITA MINTA DATA YANG AKAN DIUPDATE
  Future<bool> updateProduct(id, name, purchase, selling, qty) async {
    final url = 'https://60614ba7ac47190017a709e8.mockapi.io/api/products/' + id;
    //DAN MELAKUKAN REQUEST UNTUK UPDATE DATA PADA URL DIATAS
    //DENGAN MENGIRIMKAN DATA YANG AKAN DI-UPDATE
    final response = await http.put(url, body: {
      'id': id,
      'product_name': name,
      'product_purchase': purchase,
      'product_selling': selling,
      'product_qty': qty,
    });

    // final result = json.decode(response.body); //DECODE RESPONSE-NYA
    //LAKUKAN PENGECEKAN, JIKA STATUSNYA 200 DAN BERHASIL
    if (response.statusCode == 200) { //&& result['status'] == 'success'
      notifyListeners(); //MAKA INFORMASIKAN KE WIDGET BAHWA TERJADI PERUBAHAN PADA STATE
      return true;
    }
    return false;
  }

  Future<bool> deleteProduct(String id) async {
    final url = 'https://60614ba7ac47190017a709e8.mockapi.io/api/products/'+ id;
    final response = await http.delete(url);
    if (response.statusCode == 200) { 
      notifyListeners(); //MAKA INFORMASIKAN KE WIDGET BAHWA TERJADI PERUBAHAN PADA STATE
      return true;
    }
    return false;
  }

}