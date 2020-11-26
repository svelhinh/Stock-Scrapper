import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String title;
  final String price;
  final String link;

  Product({
    @required this.title,
    @required this.price,
    @required this.link,
  });
}
