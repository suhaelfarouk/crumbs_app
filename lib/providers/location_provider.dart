import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double? latitude;
  double? longitude;
  bool permissionAllowed = false;
  var selectedLocality;
  var selectedCity;
  var selectedPostal;
  var selectedStreet;
  bool loading = false;
  String? fullAddress = '';

  Future<void> getCurrentPosition() async {
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    // ignore: unnecessary_null_comparison
    if (position != null) {
      this.latitude = position.latitude;
      this.longitude = position.longitude;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!);
      Placemark place = placemarks[0];
      //print(place);
      this.selectedStreet = place.street!;
      this.selectedLocality = place.subLocality!;
      this.selectedCity = place.locality!;
      this.selectedPostal = place.postalCode!;

      this.permissionAllowed = true;
      notifyListeners();
    } else {
      print('Permission Not Allowed');
    }
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  // Future<void> getMoveCamera() async {
  //   final addresses = await GeoCode()
  //       .reverseGeocoding(latitude: latitude, longitude: longitude);

  //   this.selectedAddress = addresses.streetAddress!;
  //   this.selectedCity = addresses.city!;
  //   this.selectedPostal = addresses.postal!;

  // }

  Future<void> determineAddress() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude!, longitude!);
    Placemark place = placemarks[0];
    this.selectedStreet = place.street!;
    this.selectedLocality = place.subLocality!;
    this.selectedCity = place.locality!;
    this.selectedPostal = place.postalCode!;
    fullAddress =
        "${this.selectedStreet}, ${this.selectedLocality} ${this.selectedCity}, ${this.selectedPostal} ";
    print(fullAddress);
    notifyListeners();
  }

  Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', this.latitude!);
    prefs.setDouble('longitude', this.longitude!);
    prefs.setString('address', this.fullAddress!);
  }
}
