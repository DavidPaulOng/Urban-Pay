import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Accounts ")
      ),

        body: Center(child: Text(
          "Urban Pay", 
          style: TextStyle(
            fontSize: 30,
          ),)
          ),
      
    );
  }

  

}