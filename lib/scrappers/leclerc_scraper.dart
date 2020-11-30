import 'package:flutter/material.dart';
import 'package:stock_scrapper/styles.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:stock_scrapper/config.dart';
import 'package:stock_scrapper/providers/products.dart';
import 'package:stock_scrapper/providers/product.dart';

class LeclercScraper {
  WebScraper leclercScraper = WebScraper(LECLERC_URL);

  Future<bool> _loadPs5() async {
    return leclercScraper.loadWebPage(LECLERC_PS5_URL);
  }

  void addPs5(Products products) {
    List<Map<String, dynamic>> titles = leclercScraper.getElement(
      'div.article > div > div > div > div.groupe_titre',
      [],
    );

    List<Map<String, dynamic>> links = leclercScraper.getElement(
      'div.article > div > div > div > div.groupe_titre > a',
      ['href'],
    );

    List<Map<String, dynamic>> prices = leclercScraper.getElement(
      'div.article > div > div > div > div > div.tarif',
      [],
    );

    List<Map<String, dynamic>> availability = leclercScraper.getElement(
      'div.article > div > div > div > div > div.indisponible_recherche',
      [],
    );

    if (availability.isEmpty) {
      final product = Product(
        title: titles[0]["title"].trim(),
        price: prices[0]["title"].trim(),
        link: links[0]["attributes"]["href"],
        type: ProductType.PS5,
        site: ProductSite.BOULANGER,
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
