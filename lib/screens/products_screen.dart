import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cmoon_icons/flutter_cmoon_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:stock_scrapper/config.dart';
import 'package:stock_scrapper/providers/dark_theme_provider.dart';
import 'package:stock_scrapper/providers/product.dart';
import 'package:stock_scrapper/providers/products.dart';
import 'package:stock_scrapper/scrappers/boulanger_scraper.dart';
import 'package:stock_scrapper/scrappers/ldlc_scraper.dart';
import 'package:stock_scrapper/scrappers/leclerc_scraper.dart';
import 'package:stock_scrapper/scrappers/pccomponentes_scraper.dart';
import 'package:stock_scrapper/widgets/filter_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stock_scrapper/scrappers/topachat_scraper.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Timer timer;

  Products products;
  List<bool> isSelected = [false, false];

  TopAchatScraper topAchatScraper = TopAchatScraper();
  BoulangerScraper boulangerScraper = BoulangerScraper();
  LeclercScraper leclercScraper = LeclercScraper();
  PcComponentesScraper pcComponentesScraper = PcComponentesScraper();
  LdlcScraper ldlcScraper = LdlcScraper();

  List<String> sitesFiltersList = [];
  List<String> productsFiltersList = [];

  Future<void> scrap() async {
    products.reset();
    topAchatScraper.scrap(products);
    boulangerScraper.scrap(products);
    leclercScraper.scrap(products);
    pcComponentesScraper.scrap(products);
    ldlcScraper.scrap(products);
  }

  @override
  void initState() {
    super.initState();
    products = Provider.of<Products>(context, listen: false);
    Future(() => scrap()).then(
      (value) =>
          timer = Timer.periodic(Duration(seconds: 10), (Timer t) => scrap()),
    );
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

  void _onApplySitesFilter(List<String> list) {
    setState(() {
      sitesFiltersList = List.from(list);
    });
  }

  void _onApplyProductsFilter(List<String> list) {
    setState(() {
      productsFiltersList = List.from(list);
    });
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Row(
              children: [
                FilterButton(
                  onApply: _onApplySitesFilter,
                  selectedCountList: sitesFiltersList,
                  enumValues: EnumToString.toList(ProductSite.values),
                  title: "Filter Sites",
                  headlineText: "Select Sites",
                ),
                FilterButton(
                  onApply: _onApplyProductsFilter,
                  selectedCountList: productsFiltersList,
                  enumValues: EnumToString.toList(ProductType.values),
                  title: "Filter Products",
                  headlineText: "Select Products",
                ),
              ],
            ),
          ),
          products.products.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (sitesFiltersList.isNotEmpty &&
                              !sitesFiltersList.contains(
                                  EnumToString.convertToString(
                                      products.products[index].site)) ||
                          productsFiltersList.isNotEmpty &&
                              !productsFiltersList.contains(
                                  EnumToString.convertToString(
                                      products.products[index].type)))
                        return Container();
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0),
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
                              onTap: () =>
                                  _openLink(products.products[index].link),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 30.0, left: 30.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          products.products[index].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          EnumToString.convertToString(
                                              products.products[index].type),
                                        ),
                                        Text(
                                          EnumToString.convertToString(
                                              products.products[index].site),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      products.products[index].price,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: products.products.length,
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Text(
                      "EMPTY STOCK 😥",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
