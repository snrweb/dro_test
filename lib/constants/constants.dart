import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  static const DB_FETCH_LIMIT = 20;

  static const UI_OVERLAY = SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarDividerColor: null,
      statusBarColor: Color(0xff7B4397),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light);
}
