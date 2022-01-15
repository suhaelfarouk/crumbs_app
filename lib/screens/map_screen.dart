import 'dart:ui';

import 'package:crumbs_app/constants.dart';
import 'package:crumbs_app/providers/auth_provider.dart';
import 'package:crumbs_app/providers/location_provider.dart';
import 'package:crumbs_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'home_screen.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng currentLocation;
  //late String myAddress;
  late GoogleMapController _mapController;
  bool _locating = false;
  //String? _mapStyle;
  bool _loggedIn = false;
  User? user;

  @override
  void initState() {
    //Check User Logged In Or Not While Opening Map Screen
    getCurrentUser();

    super.initState();

    // rootBundle.loadString('assets/map_style.txt').then((string) {
    //   _mapStyle = string;
    // }
    // );
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);
    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      // myAddress =
      //     "${locationData.selectedStreet}, ${locationData.selectedLocality}, ${locationData.selectedCity}, ${locationData.selectedPostal} ";
    });
    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
        // _mapController.setMapStyle(_mapStyle);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20),
                child: Container(
                  //decoration:BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor),borderRadius: BorderRadius.all(Radius.circular(10))
                  //color: Colors.white,
                  height: 410,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: GoogleMap(
                          trafficEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: currentLocation,
                            zoom: 15, //14.4746,
                          ),
                          zoomControlsEnabled: true,
                          minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          mapType: MapType.normal,
                          mapToolbarEnabled: false,
                          zoomGesturesEnabled: true,
                          buildingsEnabled: false,
                          onCameraMove: (CameraPosition position) {
                            setState(() {
                              _locating = true;
                            });
                            locationData.onCameraMove(position);
                          },
                          onMapCreated: onCreated,
                          onCameraIdle: () {
                            setState(() {
                              _locating = false;
                            });
                            locationData.determineAddress();
                          },
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'images/marker.png',
                          color: Colors.black,
                          scale: 4,
                        ),
                      ),
                      Center(
                        child: SpinKitPulse(
                          color: Colors.black54,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              //bottom: 0.0,
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 170,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    right: 20,
                    left: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _locating
                          ? LinearProgressIndicator(
                              minHeight: 1,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor),
                            )
                          : Container(),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        label: Text(
                          _locating
                              ? 'Locating...'
                              : locationData.selectedLocality,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Text(
                          locationData.fullAddress!,
                          style: TextStyle(fontWeight: FontWeight.w100),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8, left: 8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: AbsorbPointer(
                            absorbing: _locating ? true : false,
                            child: ElevatedButton(
                              // style: ButtonStyle(

                              //   padding:
                              //       MaterialStateProperty.all(EdgeInsets.all(18)),
                              //   backgroundColor: _locating
                              //       ? MaterialStateProperty.all(Colors.grey)
                              //       : MaterialStateProperty.all(Colors.teal[300]),
                              // ),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(250, 55),
                                //fixedSize: Size.fromHeight(),
                                primary: _locating
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // Save Address In Shared Prefences
                                locationData.savePrefs();
                                if (_loggedIn == false) {
                                  Navigator.pushNamed(
                                      context, LoginScreen.id);
                                } else {
                                  setState(() {
                                    _auth.latitudeL = locationData.latitude;
                                    _auth.longitudeL = locationData.longitude;
                                    _auth.addressL = locationData.fullAddress;
                                  });
                                  _auth
                                      .updateUser(
                                    id: user!.uid,
                                    number: user!.phoneNumber,
                                  )
                                      .then((value) {
                                    if (value == true) {
                                      Navigator.pushNamed(
                                          context, HomeScreen.id);
                                    }
                                  });
                                }
                              },
                              child: Text('CONFIRM LOCATION'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
