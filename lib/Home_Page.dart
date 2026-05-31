import 'package:flutter/material.dart';
import 'package:marksman/profilepage.dart';
import 'package:marksman/shoesgrid.dart';
import 'package:marksman/viewallpage.dart';

import 'Shoes.dart';
import 'Shoes_data.dart';
import 'Sizechar.dart';
import 'cartpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // fetchShoes() is called once when the page loads
  // We store the Future in a variable so it doesn't
  // restart every time the widget rebuilds
  late Future<List<Shoes>> _shoesFuture;

  @override
  void initState() {
    super.initState();
    _shoesFuture = fetchShoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDBD2E0),

      // TOP-APP-BAR
      appBar: AppBar(
        backgroundColor: Color(0xFFDBD2E0),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Account-Profile icon
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => profilepage()));
                },
                iconSize: 35,
                icon: Icon(Icons.account_circle)),

            // Mid-logo
            Image.asset('assets/images/ourlogo.png',
                height: 45, color: Colors.black),

            // Size chart icon
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SizeChartPage()));
                },
                iconSize: 30,
                icon: Icon(Icons.straighten)),
          ],
        ),
      ),

      body: Column(
        children: [
          // Search bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Search'),
                Icon(Icons.search),
              ],
            ),
          ),

          Text(
            'Hit the Mark',
            style: TextStyle(color: Color(0xFFB5AFC1), fontSize: 12.5),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('HOT PICKS 🔥',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => viewallpage()));
                    },
                    child: Text('View All')),
              ),
            ],
          ),

          // FutureBuilder watches _shoesFuture and rebuilds
          // the widget automatically when the API responds
          Expanded(
            child: FutureBuilder<List<Shoes>>(
              future: _shoesFuture,
              builder: (context, snapshot) {

                // State 1: Still waiting for API response
                // Show a loading spinner
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // State 2: API returned an error
                // Show error message
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading shoes: ${snapshot.error}'),
                  );
                }

                // State 3: Data arrived successfully
                // Build the horizontal list using API data
                final shoes = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: shoes.length > 3 ? 3 : shoes.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Shoesgrid(shoes: shoes[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // BOTTOM-APP-BAR
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {},
                iconSize: 35,
                color: Color(0xFF002400),
                icon: Icon(Icons.home),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => cartpage()));
                },
                iconSize: 32,
                icon: Icon(Icons.shopping_cart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}