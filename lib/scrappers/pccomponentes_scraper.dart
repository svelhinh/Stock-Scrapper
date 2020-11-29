import 'package:flutter/material.dart';
import 'package:stock_scrapper/styles.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:stock_scrapper/config.dart';
import 'package:stock_scrapper/providers/products.dart';
import 'package:stock_scrapper/providers/product.dart';

class PcComponentesScraper {
  WebScraper topachatScraper = WebScraper(PCCOMPONENTES_URL);

  Future<bool> _load3070Gpu() async {
    return topachatScraper.loadWebPage(PCCOMPONENTES_RTX3070_URL);
  }

  Future<bool> _load3080Gpu() async {
    return topachatScraper.loadWebPage(PCCOMPONENTES_RTX3080_URL);
  }

  void addProducts(
      Products products, ProductType type, Color lightColor, Color darkColor) {
    List<Map<String, dynamic>> articles = topachatScraper.getElement(
      '#articleListContent > div.page-0 > div > article > div.c-product-card__wrapper > a',
      ['data-name', 'data-price', 'data-stock-web', 'href'],
    );

    for (var i = 0; i < articles.length; i++) {
      if (articles[i]["attributes"]["data-stock-web"] != "4" &&
          articles[i]["attributes"]["data-stock-web"] != "9999" &&
          !articles[i]["attributes"]["data-name"].contains("Reacondicionado")) {
        final product = Product(
          title: articles[i]["attributes"]["data-name"],
          price: articles[i]["attributes"]["data-price"],
          link: "$PCCOMPONENTES_URL${articles[i]["attributes"]["href"]}",
          type: type,
          site: ProductSite.PCCOMPONENTES,
          lightColor: lightColor,
          darkColor: darkColor,
        );
        products.addProduct(product);
      }
    }
  }

  Future<void> scrap(Products products) async {
    if (await _load3070Gpu())
      addProducts(
        products,
        ProductType.GPU,
        Styles.GPU_LIGHT_COLOR,
        Styles.GPU_DARK_COLOR,
      );
    if (await _load3080Gpu())
      addProducts(
        products,
        ProductType.GPU,
        Styles.GPU_LIGHT_COLOR,
        Styles.GPU_DARK_COLOR,
      );
  }
}
