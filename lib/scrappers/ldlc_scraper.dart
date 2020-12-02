import 'package:flutter/material.dart';
import 'package:stock_scrapper/styles.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:stock_scrapper/config.dart';
import 'package:stock_scrapper/providers/products.dart';
import 'package:stock_scrapper/providers/product.dart';

class LdlcScraper {
  WebScraper ldlcScraper = WebScraper(LDLC_URL);

  Future<bool> _loadGpu() async {
    return ldlcScraper.loadWebPage(LDLC_RTX3070_RTX3080_URL);
  }

  Future<bool> _loadCpu() async {
    return ldlcScraper.loadWebPage(LDLC_RYZEN5_RYZEN7_URL);
  }

  void addProducts(
      Products products, ProductType type, Color lightColor, Color darkColor) {
    List<Map<String, dynamic>> articles = ldlcScraper.getElement(
      'div.listing-product > ul > li',
      [],
    );

    if (articles.isNotEmpty) {
      List<Map<String, dynamic>> titles = ldlcScraper.getElement(
        'div.listing-product > ul > li > div > div > div > h3.title-3',
        [],
      );

      List<Map<String, dynamic>> prices = ldlcScraper.getElement(
        'div.price',
        [],
      );

      List<Map<String, dynamic>> links = ldlcScraper.getElement(
        'div.listing-product > ul > li > div > div > div > h3.title-3 > a',
        ['href'],
      );

      for (var i = 0; i < titles.length; i++) {
        final product = Product(
          title: titles[i]["title"],
          price:
              prices[i]["title"] == "" ? "Not available" : prices[i]["title"],
          link: "$LDLC_URL${links[i]['attributes']['href']}",
          type: type,
          site: ProductSite.LDLC,
          lightColor: lightColor,
          darkColor: darkColor,
        );
        products.addProduct(product);
      }
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
