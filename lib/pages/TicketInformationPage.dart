import 'package:flutter/material.dart';

class TicketInformationPage extends StatelessWidget {
  
  final String? start;
  final String? destination;
  final String? id;
  final String? datetime;
  const TicketInformationPage({super.key, required this.start, required this.destination, required this.id, required this.datetime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ticket Information"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
             Container(
              color: const Color.fromARGB(255, 239, 240, 255),
                padding: const EdgeInsets.all(15),
                width: double.infinity, // Makes it stretch to the full width
                child: Image.asset(
                  'assets/qr_code.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20,),
              const Divider(height: 1,thickness: 1,color: Color.fromARGB(255, 0, 0, 0),),
              Padding(padding:  EdgeInsets.only(top: 15.0), child: Text("Ticket ID", style: TextStyle(fontWeight: FontWeight.bold,),), ),
              Padding(padding:  EdgeInsets.symmetric(vertical: 15.0), child: Text("$id")),
        
              const Divider(height: 1,thickness: 1,color: Color.fromARGB(255, 0, 0, 0),),

              Padding(padding:  EdgeInsets.only(top: 15.0),child: Text("Start",style: TextStyle(fontWeight: FontWeight.bold,),),),
              Padding(padding:  EdgeInsets.symmetric(vertical: 15.0), child: Text("$start", textAlign: TextAlign.left,)),

              const Divider(height: 1,thickness: 1,color: Color.fromARGB(255, 0, 0, 0),),

              Padding(padding:  EdgeInsets.only(top: 15.0), child: Text("Destination", style: TextStyle(fontWeight: FontWeight.bold,),),),
              Padding(padding:  EdgeInsets.symmetric(vertical: 15.0), child: Text("$destination", textAlign: TextAlign.left,)),

              const Divider(height: 1,thickness: 1,color: Color.fromARGB(255, 0, 0, 0),),

              Padding(padding:  EdgeInsets.only(top: 15.0),child: Text("Date Bought", style: TextStyle(fontWeight: FontWeight.bold,),),),
              Padding(padding:  EdgeInsets.symmetric(vertical: 15.0),child: Text( "$datetime", textAlign: TextAlign.left,)),
        
            ],
          ),
        ),
      ),
    );
  }
}