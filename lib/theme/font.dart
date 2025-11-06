import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';

class Uiprovider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  late SharedPreferences storage;

  final darkTheam = ThemeData(
    primaryIconTheme: IconThemeData(color: Colors.white),
    buttonTheme: ButtonThemeData(buttonColor: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    fontFamily: GoogleFonts.nunitoSans().fontFamily,
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    hintColor: Colors.white,
  );

  final lightTheam = ThemeData(
    buttonTheme: ButtonThemeData(buttonColor: Colors.black),
    iconTheme: IconThemeData(color: Colors.black),
    fontFamily: GoogleFonts.nunitoSans().fontFamily,
    brightness: Brightness.light,
    primaryColor: Colors.white,
    hintColor: Colors.black,
  );

  changeTheme() {
    _isDark = !isDark;
    storage.setBool("dark", _isDark);
    notifyListeners();
  }

  init() async {
    storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool("dark") ?? false;
    notifyListeners();
  }
}
