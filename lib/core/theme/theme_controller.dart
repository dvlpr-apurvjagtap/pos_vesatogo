import 'package:flutter/material.dart';
import 'package:pos_vesatogo/core/theme/app_theme.dart';

class ThemeController extends ChangeNotifier {
  bool isDark = false;

  get getThemeMode => isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

  void changeTheme(bool value) {
    isDark = value;
    notifyListeners();
  }
}
