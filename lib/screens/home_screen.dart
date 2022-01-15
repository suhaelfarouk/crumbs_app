import 'package:crumbs_app/constants.dart';
import 'package:crumbs_app/providers/auth_provider.dart';
import 'package:crumbs_app/providers/location_provider.dart';
import 'package:crumbs_app/screens/welcome_screen.dart';
import 'package:crumbs_app/widgets/my_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    //final locationData = Provider.of<LocationProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          child: MyAppBar(),
          preferredSize: Size.fromHeight(130),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  auth.error = '';
                  FirebaseAuth.instance.signOut().then(
                    (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()),
                      );
                    },
                  );
                },
                child: Text('Log Out'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
                child: Text('Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
