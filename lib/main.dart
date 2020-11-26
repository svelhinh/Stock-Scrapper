import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_scrapper/providers/dark_theme_provider.dart';
import 'package:stock_scrapper/providers/products.dart';
import 'package:stock_scrapper/screens/products_screen.dart';
import 'package:stock_scrapper/styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => themeChangeProvider,
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Stock Scrapper',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: ProductsScreen(),
          );
        },
      ),
    );
  }
}
