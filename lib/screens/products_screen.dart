import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cmoon_icons/flutter_cmoon_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:stock_scrapper/config.dart';
import 'package:stock_scrapper/providers/dark_theme_provider.dart';
import 'package:stock_scrapper/providers/product.dart';
import 'package:stock_scrapper/providers/products.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper/web_scraper.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  WebScraper topachatScrapper;
  Timer timer;

  Products products;
  List<bool> isSelected = [false, false];

  @override
  void initState() {
    super.initState();
    topachatScrapper = WebScraper(TOPACHAT_URL);
    scrapTopAchatProducts();
    timer = Timer.periodic(
      Duration(seconds: 10),
      (Timer t) => scrapTopAchatProducts(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> scrapTopAchatProducts() async {
    if (await topachatScrapper.loadWebPage(TOPACHAT_PRODUCTS_URL)) {
      List<Map<String, dynamic>> titles = topachatScrapper.getElement(
        'section.en-stock > div.libelle > a > h3',
        [],
      );
      List<Map<String, dynamic>> prices = topachatScrapper.getElement(
        'section.en-stock > div.price > a > div.prodF > div.prod_px_euro',
        [],
      );
      List<Map<String, dynamic>> links = topachatScrapper.getElement(
        'section.en-stock > a',
        ['href'],
      );

      products.reset();

      for (var i = 0; i < titles.length; i++) {
        final product = Product(
          title: titles[i]["title"],
          price: prices[i]["title"],
          link: "$TOPACHAT_URL${links[i]['attributes']['href']}",
        );
        products.addProduct(product);
      }

      //   print("REFRESHING...");
    }
  }

  Future<void> _openLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: scrapTopAchatProducts,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              children: [
                CIcon(IconMoon.icon_sun),
                CIcon(IconMoon.icon_moon),
              ],
              onPressed: (int index) {
                themeChange.darkTheme = index != 0;
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: isSelected,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return products.products.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                  child: Container(
                    height: 100,
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      elevation: 5,
                      child: InkWell(
                        onTap: () => _openLink(products.products[index].link),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 30.0, left: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(products.products[index].title),
                              Text(products.products[index].price),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Text("");
        },
        itemCount: products.products.length,
      ),
    );
  }
}
