import 'package:coolapp_yeah/pages/PaymentConfirmationPage.dart';
import 'package:coolapp_yeah/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:coolapp_yeah/static_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../services/location_search.dart';

class DestinationSearchPage extends StatefulWidget {
  final LatLng? startlocation;
  final String? startLocationDescription;
  const DestinationSearchPage({super.key, required this.startlocation, required this.startLocationDescription});
  
  @override
  State<DestinationSearchPage> createState() => _DestinationSearchPageState();
}

class _DestinationSearchPageState extends State<DestinationSearchPage> {

  late LatLng startLocation;
  late String startLocationDescription;

  @override
  void initState() {
    super.initState();
    startLocation = widget.startlocation!; // Initialize startLocation with passed data
    startLocationDescription = widget.startLocationDescription!; // Initialize startLocation with passed data
  }
  
  List<AutocompletePrediction> placePredictions = [];
  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        "input":query,
        "key": GOOGLE_API_KEY,
      }
    );

    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null){
      PlaceAutocompleteResponse result = 
        PlaceAutocompleteResponse.parseAutocompleteResult(response);

        if (result.predictions != null){
          setState(() {
            placePredictions = result.predictions!;
          });
        }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text(
          "Destination Location",
          style: TextStyle(color: Color.fromARGB(255, 57, 15, 195),),
        ),

      ),

      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                onChanged: (value) {
                  placeAutocomplete(value);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search your location",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0), // Adjust the value as needed
                    child: Icon(Icons.search),
                  ),
                )
                )
              )
            ),
          const Divider(
            height: 4,
            thickness: 4,
            color: Color.fromARGB(255, 255, 249, 249),
          ),
          Expanded (
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index)=>LocationListTile(
                press: () async {
                  String description = placePredictions[index].description!;
                  List<Location> locations = await locationFromAddress(description);
                  Location location = locations[0];
                  LatLng latLng = LatLng(location.latitude, location.longitude);

                  final result = await Navigator.push(context, 
                  MaterialPageRoute(
                      builder: (context) => PaymentConfirmationPage(
                        startLocation: startLocation, 
                        startLocationDescription: startLocationDescription,
                        destinationLocation: latLng,
                        destinationLocationDescription: description
                        ),
                    ),

                  );

                  
                  Navigator.pop(context, {     
                  'destination': latLng
                 });

                },
                location: placePredictions[index].description!, 
                ), 
              ), 
            ) 
        ],
      ),
    );
  }
}
