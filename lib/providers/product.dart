import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ProductType {
  CPU,
  GPU,
  PS5,
}

class Product with ChangeNotifier {
  final String title;
  final String price;
  final String link;
  final ProductType type;
  final Color lightColor;
  final Color darkColor;

  Product({
    @required this.title,
    @required this.price,
    @required this.link,
    @required this.type,
    @required this.lightColor,
    @required this.darkColor,
  });
}
