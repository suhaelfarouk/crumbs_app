import 'dart:async';

import 'package:crumbs_app/constants.dart';
import 'package:crumbs_app/providers/auth_provider.dart';
import 'package:crumbs_app/screens/login_screen.dart';
import 'package:crumbs_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'providers/location_provider.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/onboard_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: myMaroon,
        primaryColorLight: myLightMaroon,
        hintColor: myGrey,
        appBarTheme: AppBarTheme(color: myMaroon),
        fontFamily: 'NeueHaasGroteskTextPro',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        MapScreen.id: (context) => MapScreen(),
        LoginScreen.id: (context) => LoginScreen(),
      },
    );
  }
}
