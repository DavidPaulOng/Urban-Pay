import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final List<Map<String, dynamic>> TRANSIT_POINTS = [];

Future<void> readJson() async {
    final String response = await rootBundle.loadString("assets/transit_points.json");
    final data = await json.decode(response);


    for (var point in data["data"]) {

      String temp = point["lintang"].toString().replaceAll(',', '.').replaceAll(' ', '').replaceAll(RegExp(r'[^0-9\-.]'), '');
      if (temp.contains('\n')) {
        temp = temp.substring(0, temp.indexOf('\n'));
      } 
      
      double cleanLatitude = double.parse(temp);


      temp = point["bujur"].toString().replaceAll(',', '.').replaceAll(' ', '').replaceAll(RegExp(r'[^0-9\-.]'), '');
      if (temp.contains('\n')) {
        temp = temp.substring(0, temp.indexOf('\n'));
      } 
      double cleanLongitude = double.parse(temp);


      TRANSIT_POINTS.add({
        "coordinates": {
          "latitude": cleanLatitude,  // Store as latitude
          "longitude": cleanLongitude,   // Store as longitude
        },
        "id" : point["id_halte"]
      });
        
    }

    // print(TRANSIT_POINTS);
}


// ignore: constant_identifier_names
const String GOOGLE_API_KEY = "AIzaSyBauE9fID2MHJV5fJaYFVnVTImyUYUomKA";
