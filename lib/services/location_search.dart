import 'dart:convert';

import 'package:flutter/material.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.location,
    required this.press,
  });

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: Row(
            mainAxisSize: MainAxisSize.min, // Prevent the row from taking extra space
            children: [
              SizedBox(width: 20), 
              Icon(Icons.location_on_outlined),
              SizedBox(width: 10), // Add space between icon and text
            ],
          ),
          title: Text(
              location,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
        ),
        const Divider(
          height: 2,
          thickness: 2,
          color: Color.fromARGB(255, 252, 243, 243)
        )
      ],
    );
  }
}

class AutocompletePrediction {
  final String? description;
  final StructuredFormatting? structuredFormatting;
  final String? placeId;
  final String? reference;

  AutocompletePrediction({
    this.description,
    this.structuredFormatting,
    this.placeId,
    this.reference
  });

  
  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) { 
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting:
      json['structured_formatting'] != null
        ? StructuredFormatting.fromJson(json['structured_formatting'])
        : null,
      ); // AutocompletePrediction
  }
}
class StructuredFormatting {
  final String? mainText;
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json){
    return StructuredFormatting(

      mainText: json['main_text'] as String?,
      secondaryText:json['secondary_text'] as String?,
    );
  }
  
}


class PlaceAutocompleteResponse {
  
  /// The Autocomplete response contains place predictions and status class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

    factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json_) { 
      return PlaceAutocompleteResponse(
      status: json_['status'] as String?, 
      predictions: json_['predictions']?.map<AutocompletePrediction>(
            (json_) => AutocompletePrediction.fromJson(json_))
          .toList(),
      ); // PlaceAutocompleteResponse
    }
  static PlaceAutocompleteResponse parseAutocompleteResult(
  String responseBody){
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}
