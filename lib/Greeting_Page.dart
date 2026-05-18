import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home_Page.dart';

class GreatingPage extends StatelessWidget {
  const GreatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDBD2E0),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Center(
              child: Text("Welcome To My E-COMMERCE APPLICATION",
              ),
            ),
          ),

          //LOGO
          const SizedBox(height: 15),
          Image.asset('assets/images/ourlogo.png',height:50,),

          //Image
        //  const SizedBox(height: 25),
          Image.asset('assets/images/pppeee.png',height:200,),

          //Button
          const SizedBox(height: 35),
          Center(
            child:ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HomePage(),)
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF002400),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('START SHOPPING',
                style: TextStyle(
                  color: Colors.white,fontSize: 18,
                  fontWeight: FontWeight.bold, ),
              ),
            )

          )
        ],
      ),
    );
    
  }
}
