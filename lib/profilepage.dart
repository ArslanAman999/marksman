import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profilepage extends StatefulWidget {
  const profilepage({super.key});

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDBD2E0),
      appBar: AppBar(
        backgroundColor: Color(0xFFDBD2E0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //logo
            Image.asset(
              'assets/images/ourlogo.png',
              height: 45,
              color: Colors.black,
            ),

            IconButton(
              onPressed: () {},
              icon: Icon(Icons.account_circle),
              iconSize: 35,
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(100.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: CircleAvatar(
              radius: 70,
              child: Icon(Icons.person, size: 50, color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Full Name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your full name',
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Email',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Phone No',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your phone number',
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your address',
            ),
          ),
          SizedBox(height: 30),
        ]),
      ),
    );
  }
}
