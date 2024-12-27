
import 'package:coolapp_yeah/pages/TicketInformationPage.dart';
import 'package:coolapp_yeah/services/database_service.dart';
import 'package:flutter/material.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => TicketPageState();
}

class TicketPageState extends State<TicketPage> {
  final DatabaseService _databaseservice = DatabaseService.instance;
  // final String? _ticket = "Ticket0";
  int counter = 0;
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Tickets ")
      ),
        floatingActionButton: Stack(
          
          children: [
            // _addTicketButton(),
            _deleteData(),
          ],
        ),
        body: _ticketList(),
      
    );
  }

  // Widget _addTicketButton() {

  //   return Positioned(
  //     bottom: 70, 
  //     right: 15,
  //     child: FloatingActionButton(
  //       heroTag: 'ticketfloatingtag',
  //       onPressed: () {
  //         // _databaseservice.addTicket("startstart", "destinationdestination");
  //         // counter++;
  //         setState(() {});
  //       }, 
  //       child: const Icon(Icons.add,)
  //       ),
  //   );
  // }

  Widget _deleteData() {
    return Positioned(
      bottom: 0,
      right: 15,
      child: FloatingActionButton(
        heroTag: 'ticketdeletefloatingtag',
        onPressed: () {
          _databaseservice.deleteDatabaseFile();
          setState(() {});
        },
        child: const Icon(Icons.delete_forever_outlined,)
      ));
  }

  Widget _ticketList() {
    return FutureBuilder(
      future: _databaseservice.getData(), 
      builder: (context, snapshot){
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index){
            Ticket ticket = snapshot.data![index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, 
                  MaterialPageRoute(
                      builder: (context) => TicketInformationPage(start: ticket.start, destination: ticket.destination,id: ticket.id, datetime: ticket.datetime),
                  ),

                );
              },
              child: Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  // padding: EdgeInsets.zero,
                  color: const Color.fromARGB(255, 190, 244, 146),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Text("Ticket #${ticket.id}", 
                       textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                       
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(height: 10,),
                      Text("From: ${cutOffString(ticket.start, 40)}...", textAlign: TextAlign.left,),
              
                      Text("To  : ${cutOffString(ticket.destination, 40)}...", textAlign: TextAlign.left,),
                    ],
                  )
              
              ),
            );
          }
          );
      });
  }

  
  String cutOffString(String originalString, int maxLength) {
    return originalString.length > maxLength 
      ? originalString.substring(0, maxLength) 
      : originalString;
  } 

}