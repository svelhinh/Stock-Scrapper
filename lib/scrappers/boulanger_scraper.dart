import 'package:flutter/material.dart';
import 'package:stock_scrapper/styles.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:stock_scrapper/config.dart';
import 'package:stock_scrapper/providers/products.dart';
import 'package:stock_scrapper/providers/product.dart';

class BoulangerScraper {
  WebScraper boulangerScraper = WebScraper(BOULANGER_URL);

  Future<bool> _loadPs5() async {
    return boulangerScraper.loadWebPage(BOULANGER_PS5_URL);
  }

  void addPs5(Products products) {
    List<Map<String, dynamic>> availability = boulangerScraper.getElement(
      'svg.decepticon-available',
      [],
    );

    if (availability.isNotEmpty) {
      List<Map<String, dynamic>> titles = boulangerScraper.getElement(
        'div.middle > div.left > div.top > div.left > h1',
        [],
      );

      List<Map<String, dynamic>> prices = boulangerScraper.getElement(
        'div.pb-left > div.price > p.fix-price',
        [],
      );

      final product = Product(
        title: titles[0]["title"].trim(),
        price: prices[0]["title"].trim(),
        link: "$BOULANGER_URL$BOULANGER_PS5_URL",
        type: ProductType.PS5,
        lightColor: Styles.PS5_LIGHT_COLOR,
        darkColor: Styles.PS5_DARK_COLOR,
      );
      products.addProduct(product);
    }
  }

  Future<void> scrap(Products products) async {
    if (await _loadPs5()) addPs5(products);
  }
}
