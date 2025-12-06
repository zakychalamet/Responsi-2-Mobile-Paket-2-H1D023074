import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiUrl {
  
  static String get baseUrl {
    if (kIsWeb) {
      
      return 'http://localhost:8080';
    } else if (Platform.isAndroid) {
      
      return 'http://10.0.2.2:8080';
    } else if (Platform.isIOS) {
      
      return 'http://localhost:8080';
    } else {
  
      return 'http://localhost:8080';
    }
  }

  static String get registrasi => baseUrl + '/registrasi';
  static String get login => baseUrl + '/login';
  static String get listProduk => baseUrl + '/produk';
  static String get createProduk => baseUrl + '/produk';

  static String updateProduk(int id) {
    return baseUrl + '/produk/' + id.toString();
  }

  static String showProduk(int id) {
    return baseUrl + '/produk/' + id.toString();
  }

  static String deleteProduk(int id) {
    return baseUrl + '/produk/' + id.toString();
  }
}
