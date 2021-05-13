import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'controllers/product_provider.dart';
import 'views/products/screen/product_detail.dart';
import 'views/products/screen/product_screen.dart';
import 'views/products/screen/product_search_screen.dart';
import 'views/products/screen/cart_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductProvider(),
        ),
      ],
      child: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFF000000),
          systemNavigationBarDividerColor: null,
          statusBarColor: Color(0xff7B4397),
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light),
    );
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        maxWidth: 1200,
        minWidth: 350,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(350, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
        background: Container(
          color: Color(0xFFF5F5F5),
        ),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff9F5DE2),
        primaryColorLight: Colors.white,
        primaryColorDark: Color(0xff7B4397),
        accentColor: Color(0xff0CB8B6),
        backgroundColor: Color(0xff909090),
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.white),
          subtitle2: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Color(0xff909090)),
        primaryIconTheme: IconThemeData(color: Colors.black),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (ctx) => ProductScreen(),
        ProductSearchScreen.routeName: (ctx) => ProductSearchScreen(),
        ProductDetail.routeName: (ctx) => ProductDetail(),
        CartScreen.routeName: (ctx) => CartScreen(),
      },
    );
  }
}
