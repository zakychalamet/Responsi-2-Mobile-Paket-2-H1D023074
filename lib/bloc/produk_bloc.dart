import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    try {
      String apiUrl = ApiUrl.listProduk;
      var response = await Api().get(apiUrl);
      var jsonObj = json.decode(response.body);
      
      // Cek apakah response status false atau data bukan list
      if (jsonObj['status'] == false || jsonObj['data'] is! List) {
        return [];
      }
      
      List<dynamic> listProduk = jsonObj['data'] as List<dynamic>;
      List<Produk> produks = [];
      for (var item in listProduk) {
        produks.add(Produk.fromJson(item as Map<String, dynamic>));
      }
      return produks;
    } catch (e) {
      print('Error getProduks: $e');
      return [];
    }
  }

  static Future addProduk({Produk? produk}) async {
    try {
      String apiUrl = ApiUrl.createProduk;
      var body = {
        "nama": produk!.namaProduk,
        "harga": int.parse(produk.hargaProduk.toString()),
        "jumlah": int.parse(produk.jumlah.toString()),
        "tanggal_masuk": produk.tanggalMasuk,
        "tanggal_kedaluwarsa": produk.tanggalKedaluwarsa
      };
      print('DEBUG addProduk - URL: $apiUrl');
      print('DEBUG addProduk - Body: $body');
      var response = await Api().post(apiUrl, body);
      print('DEBUG addProduk - Response: ${response.body}');
      var jsonObj = json.decode(response.body);
      return jsonObj['status'];
    } catch (e) {
      print('Error addProduk: $e');
      return false;
    }
  }

  static Future updateProduk({required Produk produk}) async {
    try {
      String apiUrl = ApiUrl.updateProduk(int.parse(produk.id!));
      var body = {
        "nama": produk.namaProduk,
        "harga": int.parse(produk.hargaProduk.toString()),
        "jumlah": int.parse(produk.jumlah.toString()),
        "tanggal_masuk": produk.tanggalMasuk,
        "tanggal_kedaluwarsa": produk.tanggalKedaluwarsa
      };
      print('DEBUG updateProduk - URL: $apiUrl');
      print('DEBUG updateProduk - Body: $body');
      var response = await Api().put(apiUrl, body);
      print('DEBUG updateProduk - Response: ${response.body}');
      var jsonObj = json.decode(response.body);
      return jsonObj['status'];
    } catch (e) {
      print('Error updateProduk: $e');
      return false;
    }
  }

  static Future<bool> deleteProduk({int? id}) async {
    try {
      String apiUrl = ApiUrl.deleteProduk(id!);
      print('DEBUG deleteProduk - URL: $apiUrl');
      var response = await Api().delete(apiUrl);
      print('DEBUG deleteProduk - Response: ${response.body}');
      var jsonObj = json.decode(response.body);
      print('DEBUG deleteProduk - Status: ${jsonObj['status']}');
      return jsonObj['status'] == true;
    } catch (e) {
      print('Error deleteProduk: $e');
      return false;
    }
  }
}