import 'package:flutter/material.dart';
import 'package:marksman/shoesgrid.dart';

import 'Shoes.dart';
import 'Shoes_data.dart';
import 'cartpage.dart';

class viewallpage extends StatefulWidget {
  const viewallpage({super.key});

  @override
  State<viewallpage> createState() => _viewallpageState();
}

class _viewallpageState extends State<viewallpage> {

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
      appBar: AppBar(
        backgroundColor: Color(0xFFDBD2E0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Item Page'),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => cartpage()));
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Search bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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

          // Shoes grid with FutureBuilder
          Expanded(
            child: FutureBuilder<List<Shoes>>(
              future: _shoesFuture,
              builder: (context, snapshot) {

                // Waiting for API response
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // API returned an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading shoes: ${snapshot.error}'),
                  );
                }

                // Data loaded successfully — show full grid
                final shoes = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: shoes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
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

      bottomNavigationBar: BottomAppBar(height: 25),
    );
  }
}