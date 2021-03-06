import 'package:beacon_bus/blocs/login/login_provider.dart';
import 'package:beacon_bus/blocs/teacher/teacher_provider.dart';
import 'package:beacon_bus/blocs/parent/parent_provider.dart';
import 'package:beacon_bus/screens/login_screen.dart';
import 'package:beacon_bus/screens/teacher/teacher_home_screen.dart';
import 'package:beacon_bus/screens/parent/parent_home_screen.dart';
import 'package:beacon_bus/screens/teacher/teacher_log_screen.dart';
import 'package:flutter/material.dart';
import 'package:beacon_bus/screens/beacon/beacon_screen.dart';

class BeaconBusApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LoginProvider(
      child: ParentProvider(
        child: TeacherProvider(
          child: MaterialApp(
            title: 'School Bus',
            theme: ThemeData(
              primarySwatch: Colors.yellow,
            ),
            home: LoginScreen(),
            routes: {
              '/login': (context) => LoginScreen(),
              '/parent': (context) => ParentHomeScreen(),
              '/teacher': (context) => TeacherHomeScreen(),
              '/teacherlog': (context) => TeacherLogScreen(),
              '/beacon':(context) => BeaconScreen(),
            },
          ),
        ),
      ),
    );
  }
}