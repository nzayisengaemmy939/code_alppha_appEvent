import 'package:code_alpha_campus_event/pages/home.dart';
import 'package:code_alpha_campus_event/components/bottom_nav.dart';
import 'package:code_alpha_campus_event/pages/single.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const String nav = '/';
  static const String home = '/home';
 static const String single = '/single';
  static final Map<String, WidgetBuilder> routes = {
    nav: (context) => const BottomNav(),
    home: (context) => const Home(),
    single:(context)=>const Single()
  };
}
