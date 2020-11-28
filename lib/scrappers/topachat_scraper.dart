import 'package:flutter/material.dart';
import 'package:stock_scrapper/styles.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:stock_scrapper/config.dart';
import 'package:stock_scrapper/providers/products.dart';
import 'package:stock_scrapper/providers/product.dart';

class TopAchatScraper {
  WebScraper topachatScraper = WebScraper(TOPACHAT_URL);

  Future<bool> _loadGpu() async {
    return topachatScraper.loadWebPage(TOPACHAT_RTX3070_RTX3080_URL);
  }

  Future<bool> _loadCpu() async {
    return topachatScraper.loadWebPage(TOPACHAT_RYZEN5_RYZEN7_URL);
  }

  void addProducts(
      Products products, ProductType type, Color lightColor, Color darkColor) {
    List<Map<String, dynamic>> titles = topachatScraper.getElement(
      'section.en-stock > div.libelle > a > h3',
      [],
    );
    List<Map<String, dynamic>> prices = topachatScraper.getElement(
      'section.en-stock > div.price > a > div.prodF > div.prod_px_euro',
      [],
    );
    List<Map<String, dynamic>> links = topachatScraper.getElement(
      'section.en-stock > a',
      ['href'],
    );

    for (var i = 0; i < titles.length; i++) {
      final product = Product(
        title: titles[i]["title"],
        price: prices[i]["title"],
        link: "$TOPACHAT_URL${links[i]['attributes']['href']}",
        type: type,
        lightColor: lightColor,
        darkColor: darkColor,
      );
      products.addProduct(product);
    }
  }

  Future<void> scrap(Products products) async {
    if (await _loadGpu())
      addProducts(
        products,
        ProductType.GPU,
        Styles.GPU_LIGHT_COLOR,
        Styles.GPU_DARK_COLOR,
      );
    if (await _loadCpu())
      addProducts(
        products,
        ProductType.CPU,
        Styles.CPU_LIGHT_COLOR,
        Styles.CPU_DARK_COLOR,
      );
  }
}
