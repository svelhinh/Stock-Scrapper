import 'package:flutter/material.dart';

class Styles {
  static const Color CPU_LIGHT_COLOR = Color(0xffececec);
  static const Color GPU_LIGHT_COLOR = Color(0xffececec);
  static const Color PS5_LIGHT_COLOR = Color(0xffececec);

  static const Color CPU_DARK_COLOR = Color(0xff833471);
  static const Color GPU_DARK_COLOR = Color(0xff006266);
  static const Color PS5_DARK_COLOR = Color(0xff1289A7);

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.red,
      primaryColor: isDarkTheme ? Color(0xff30475e) : Color(0xffececec),
      backgroundColor: isDarkTheme ? Color(0xff222831) : Color(0xffF1F5FB),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Color(0xffececec) : Color(0xff222831),
      cardColor: isDarkTheme ? Color(0xFF151515) : Color(0xffececec),
      canvasColor: isDarkTheme ? Color(0xff222831) : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}
