import 'package:crumbs_app/providers/auth_provider.dart';
import 'package:crumbs_app/providers/location_provider.dart';
import 'package:crumbs_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String? _location;

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('address');
    setState(() {
      _location = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    return AppBar(
      elevation: 0,
      leading: Container(),
      leadingWidth: 1,
      title: TextButton(
        onPressed: () {
          locationData.getCurrentPosition();
          if (locationData.permissionAllowed == true) {
            Navigator.pushNamed(context, MapScreen.id);
          } else {
            print('Permission Not Allowed');
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 10,
                right: 10,
              ),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.edit_location_alt),
                  color: Theme.of(context).primaryColor,
                  iconSize: 20,
                  onPressed: () {},
                ),
              ),
            ),
            Flexible(
              child: Text(
                _location == null ? 'Set Delivery Address' : _location!,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.account_box),
      //     color: Colors.white,
      //     onPressed: () {},
      //   )
      // ],
      
      centerTitle: true,
      bottom: PreferredSize(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            left: 20,
            bottom: 20,
            top: 5,
          ),
          child: TextField(
            cursorColor: Theme.of(context).primaryColor,
            autofocus: false,
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColor,
                ),
                focusColor: Theme.of(context).primaryColor,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white),
          ),
        ),
        preferredSize: Size.fromHeight(60),
      ),
    );
  }
}
