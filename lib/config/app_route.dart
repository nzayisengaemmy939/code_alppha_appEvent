import 'dart:io';

import 'package:code_alpha_campus_event/components/bottom_nav.dart';
import 'package:code_alpha_campus_event/pages/add_event.dart';
import 'package:code_alpha_campus_event/pages/campus_update.dart';
import 'package:code_alpha_campus_event/pages/edit.dart';
import 'package:code_alpha_campus_event/pages/home.dart';
import 'package:code_alpha_campus_event/pages/link.dart';
import 'package:code_alpha_campus_event/pages/single.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const String nav = '/';
  static const String campusUpdate = '/campusUpdat';
  static const String home = '/home';
 static const String single = '/single';
  static const String link = '/link';
  static const String edit = '/edit';
   static const String event = '/event';


  static final Map<String, WidgetBuilder> routes = {
    nav: (context) => const BottomNav(),
    home: (context) => const Home(),
    single:(context)=>const Single(),
    campusUpdate:(context)=>const CampusUpdate(),
    link:(context)=>const AllLinks(),
    edit:(context)=>const Edit(),
    event:(context)=>const AddEvent()

  };
}
