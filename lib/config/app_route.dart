
import 'package:code_alpha_campus_event/components/bottom_nav.dart';
import 'package:code_alpha_campus_event/pages/add_event.dart';
import 'package:code_alpha_campus_event/pages/campus_update.dart';
import 'package:code_alpha_campus_event/pages/dashboard.dart';
import 'package:code_alpha_campus_event/pages/edit.dart';
import 'package:code_alpha_campus_event/pages/edit_profile.dart';
import 'package:code_alpha_campus_event/pages/events.dart';
import 'package:code_alpha_campus_event/pages/home.dart';
import 'package:code_alpha_campus_event/pages/link.dart';
import 'package:code_alpha_campus_event/pages/login.dart';
import 'package:code_alpha_campus_event/pages/register.dart';
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
   static const String profile = '/profile';
   static const login  = '/login';
    static const register  = '/register';
    static const dash  = '/dash';
    static const ev  = '/events';
    static const bottom  = '/bottom';

  




  static final Map<String, WidgetBuilder> routes = {
    nav: (context) => const BottomNav(),
    home: (context) => const Home(),
    single:(context)=>const Single(),
    campusUpdate:(context)=>const CampusUpdate(),
    link:(context)=>const AllLinks(),
    edit:(context)=>const Edit(),
    event:(context)=>const AddEvent(),
    profile:(context)=>const EditProfile(),
    login:(context)=>const Login(),
     register:(context)=>Register(),
     dash:(context)=>Dashboard(),
      ev:(context)=>const Events(),
       bottom:(context)=>const BottomNav(),



  };
}
