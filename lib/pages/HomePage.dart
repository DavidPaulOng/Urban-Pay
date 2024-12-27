import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:coolapp_yeah/pages/SearchPage.dart';
import 'package:coolapp_yeah/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'dart:math';

import 'package:permission_handler/permission_handler.dart' as permission;




class HomePage extends StatefulWidget {
  final LatLng? startLocation;
  final LatLng? destinationLocation;

  // Constructor to receive the data
  const HomePage({
    super.key,
    this.startLocation,
    this.destinationLocation,
  });
  
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  static const LatLng origin = LatLng(-6.178999, 106.831160);  
  static const LatLng destination = LatLng(-6.1628566, 106.82003166);  


  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> _markers = {};  // Store markers here\
  bool _isLoading = false;     


  LatLng? _currentP;
  LatLng? startLocation = LatLng(-6.178999, 106.831160); 
  LatLng? destinationLocation = LatLng(-6.1628566, 106.82003166); 


  @override
  void initState(){
    super.initState();

    
    // loadMarkers();

    requestBluetoothPermission();

    getLocationUpdates().then((value) =>{
      getPolyLinePoints().then((coordinates) => {
       generatePolyLine(coordinates).then((_) =>{
            _fitPolylinesToMap()
          })
        })
      }
    );

    
  }

  @override
  Widget build(BuildContext context){
              
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0), // Adjust the value to move it up
        child: SizedBox(
          width: 150,
          child: FloatingActionButton(
            backgroundColor:const ui.Color.fromARGB(255, 244, 167, 67),
            heroTag: 'mapfloatingtag',
            onPressed: ()  async {

              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()
                  ) // remove all until stack is empty 
                );
              
              if (result != null){
                setState(() {
                  startLocation = result['start'];
                  destinationLocation = result['destination'];
          
                getPolyLinePoints().then((coordinates) => {
                  generatePolyLine(coordinates).then((_) =>{
                        _fitPolylinesToMap()
                      })
                  });
          
                  // loadMarkers();
                });
          
              
              }
            
            },
            child: Text(
              "Buy Ticket"
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const ui.Color.fromARGB(255, 244, 167, 67),
        title: const Text(" Map ")
      ),
      body: GoogleMap(

        onMapCreated: (
          (GoogleMapController controller) => _mapController.complete(controller)
          ),

        initialCameraPosition: CameraPosition(
          target: startLocation!,
          zoom: 12,
          ),
          markers: _markers,
          polylines: Set<Polyline>.of(polylines.values),                                           
        ),
      
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async{
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 14, 
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> _fitPolylinesToMap() async {
    if (polylines.isEmpty) return;

    // Combine all points from all polylines
    List<LatLng> allPoints = [];
    for (var polyline in polylines.values) {
      allPoints.addAll(polyline.points);
    }

    // Ensure there are points to calculate bounds
    if (allPoints.isEmpty) return;

    // Find the southwest and northeast corners
    LatLng southwest = LatLng(
      allPoints.map((point) => point.latitude).reduce((a, b) => a < b ? a : b),
      allPoints.map((point) => point.longitude).reduce((a, b) => a < b ? a : b),
    );

    LatLng northeast = LatLng(
      allPoints.map((point) => point.latitude).reduce((a, b) => a > b ? a : b),
      allPoints.map((point) => point.longitude).reduce((a, b) => a > b ? a : b),
    );

    LatLngBounds bounds = LatLngBounds(southwest: southwest, northeast: northeast);

    final GoogleMapController controller = await _mapController.future;
   
    // Animate the camera to fit the bounds
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
}


  Future<void> getLocationUpdates() async{

    if (!await permission.Permission.location.isGranted) {
      permission.Permission.location.request();
    }

    // bool serviceEnabled;
    // PermissionStatus permissionGranted;

    // serviceEnabled = await _locationController.serviceEnabled();
    // if (serviceEnabled){
    //   serviceEnabled = await _locationController.requestService();
    // } else{
    //   return;
    // }
    // permissionGranted = await _locationController.hasPermission();
    // if(permissionGranted == PermissionStatus.denied){
    //   permissionGranted = await _locationController.requestPermission();
    //   if(permissionGranted != PermissionStatus.granted){
    //     return;
    //   }
    // }

    // _locationController.onLocationChanged.listen((LocationData currentLocation){
    //     if (currentLocation.latitude != null && currentLocation.longitude != null){
    //       setState(() {
    //         _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);

    //         // _cameraToPosition(startLocation!);
    //       });
    //     }
    // });
  }

  
  Future<void> requestBluetoothPermission() async {
    if (!await permission.Permission.bluetooth.isGranted) {
      permission.Permission.bluetooth.request();
    }
}


  Future<List<LatLng>> getPolyLinePoints() async{
    List<LatLng> polyLineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_API_KEY,
      request: PolylineRequest(
        mode: TravelMode.transit,
        origin: PointLatLng(startLocation!.latitude, startLocation!.longitude), 
        destination: PointLatLng(destinationLocation!.latitude, destinationLocation!.longitude))
    );
      if (result.points.isNotEmpty){
        for (var point in result.points) {
          polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else{
        // ignore: avoid_print
        print(result.errorMessage);
      }

      return polyLineCoordinates;
  }

  Future<void> generatePolyLine(List<LatLng> coordinates) async{
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: const ui.Color.fromARGB(255, 0, 0, 0),
      points: coordinates,
      width:4
    );
    setState(() {
      polylines[id] = polyline;
    });
  }


  double calculateDistance(LatLng loc1, LatLng loc2) {
    const earthRadiusKm = 6371.0;

    double lat1 = loc1.latitude;
    double lon1 = loc1.longitude;
    double lat2 = loc2.latitude;
    double lon2 = loc2.longitude;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c; // Distance in kilometers
  }
  // Helper function to convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

 List<Map<String, dynamic>> filterLocation(LatLng center, List<Map<String, dynamic>> locations, double maxRadius)
  {
    print(locations);
  return locations
      // radius in kilometers
      .where((location){

        if(calculateDistance(center, 
          LatLng(
           location["coordinates"]["latitude"],
          location["coordinates"]["longitude"]
        )) <= maxRadius){
          return true;
        }

        return false;

        
      })
      .toList();
  }

  

  Future<void> loadMarkers() async{
    
    await readJson();
    BitmapDescriptor descriptor = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)), // Optional: size of the marker
      'assets/busIcon.png', // Path to your asset
    );

    List<Map<String, dynamic>> locations = filterLocation(startLocation!, TRANSIT_POINTS, 0.75);
    Set<Marker> markers = {};
    // print(calculateDistance(origin, origin));
    for (var loc in locations){
      markers.add(
        Marker(
              markerId: MarkerId(loc["id"]),
              icon: descriptor,
              position: LatLng(loc["coordinates"]["latitude"], loc["coordinates"]["longitude"]),
            ),
      );
    }
    setState(() {
      _markers = markers;  // Store the result in _markers
      _isLoading = false;  // Set loading state to false
    });
    

  }




}