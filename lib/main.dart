import 'package:coolapp_yeah/pages/AccountPage.dart';
import 'package:flutter/material.dart';
import 'package:coolapp_yeah/pages/HomePage.dart';
import 'package:coolapp_yeah/pages/TicketPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final LatLng? startLocation;
  final LatLng? destinationLocation;
  // Constructor to accept data
  const MyApp({
    super.key,
    this.startLocation,
    this.destinationLocation,
  });

  @override
  State<MyApp> createState() => AppState();
}

class AppState extends State<MyApp> {
  int currentPageIndex = 0;
  LatLng? startLocation;
  LatLng? destinationLocation;
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: IndexedStack(
          index: currentPageIndex,
          children: [
            HomePage(startLocation: widget.startLocation, destinationLocation: widget.destinationLocation),
            TicketPage(),
            AccountPage(),
          ],
        ),
        
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index){
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.map), 
                label: "Map",       
              ),
              NavigationDestination(
                icon: Icon(Icons.airplane_ticket), 
                label: "Ticket"
              ),
              NavigationDestination(
                icon: Icon(Icons.circle), 
                label: "Profile"
              ),
          ],
          selectedIndex: currentPageIndex,
          
        ),
      ),
    );
  }
}
