import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cmoon_icons/flutter_cmoon_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:stock_scrapper/config.dart';
import 'package:stock_scrapper/providers/dark_theme_provider.dart';
import 'package:stock_scrapper/providers/products.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stock_scrapper/scrappers/topachat_scrapper.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Timer timer;

  Products products;
  List<bool> isSelected = [false, false];

  TopAchatScrapper topAchatScrapper = TopAchatScrapper();

  Future<void> scrap() async {
    products.reset();
    topAchatScrapper.scrap(Provider.of<Products>(context, listen: false));
  }

  @override
  void initState() {
    super.initState();
    topAchatScrapper.scrap(Provider.of<Products>(context, listen: false));
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => scrap());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
          onPressed: () => scrap(),
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
      body: products.products.isNotEmpty
          ? ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                  child: Container(
                    height: 100,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: themeChange.darkTheme
                          ? products.products[index].darkColor
                          : products.products[index].lightColor,
                      elevation: 5,
                      child: InkWell(
                        onTap: () => _openLink(products.products[index].link),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 30.0, left: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(products.products[index].title),
                                  Text(
                                    EnumToString.convertToString(
                                        products.products[index].type),
                                  ),
                                ],
                              ),
                              Text(products.products[index].price),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: products.products.length,
            )
          : Center(
              child: Text(
              "Nothing in stock",
              style: TextStyle(fontSize: 25),
            )),
    );
  }
}
