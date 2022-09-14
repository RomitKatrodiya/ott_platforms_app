import 'package:flutter/material.dart';
import 'package:ott_platforms_app/screens/home_page.dart';
import 'package:ott_platforms_app/screens/website_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const HomePage(),
        "website_page": (context) => const WebsitePage(),
      },
    ),
  );
}
