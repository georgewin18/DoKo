import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences extends ChangeNotifier {
  bool _isdarkMode = false;
  String _language = 'en';
  bool _knewTutorial = false;
  String _username = "";
  List<Color> _colorPreference = violet;

  bool get isdarkMode => _isdarkMode;
  String get language => _language;
  bool get knewTutorial => _knewTutorial;
  String get username => _username;
  List<Color> get colorPreference => _colorPreference;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isdarkMode = prefs.getBool('isdarkMode') ?? false;
    _language = prefs.getString('language') ?? 'en';
    _knewTutorial = prefs.getBool('knewTutorial') ?? false;
    _username = prefs.getString('username') ?? '';
    List<String>? savedColors = prefs.getStringList('colorPreference');
    if (savedColors != null) {
      _colorPreference =
          savedColors.map((hex) => Color(int.parse(hex, radix: 16))).toList();
    } else {
      _colorPreference = violet;
    }
    notifyListeners();
  }

  Future<void> setColorPreference(List<Color> colors) async {
    _colorPreference = colors;
    final prefs = await SharedPreferences.getInstance();

    List<String> colorStrings =
        colors.map((c) => c.value.toRadixString(16).padLeft(8, '0')).toList();
    await prefs.setStringList('colorPreference', colorStrings);

    notifyListeners();
  }

  void setIsDarkMode(bool value) async {
    _isdarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isdarkMode', value);
    notifyListeners();
  }

  void setKnewTutorial(bool value) async {
    _knewTutorial = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('knewTutorial', value);
    notifyListeners();
  }

  void setUsername(String value) async {
    _username = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', value);
    notifyListeners();
  }

  void setLanguage(String value) async {
    _language = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
    notifyListeners();
  }
}
