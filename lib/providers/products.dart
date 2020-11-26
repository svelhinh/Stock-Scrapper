import 'package:flutter/foundation.dart';
import 'package:stock_scrapper/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void reset() {
    _products.clear();
    notifyListeners();
  }
}
