import 'package:flutter/material.dart';
import 'package:marksman/shoesgrid.dart';
import 'package:marksman/cart_model.dart';

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
    cartModel.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    cartModel.removeListener(_onCartChanged);
    super.dispose();
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
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.shopping_cart),
                  if (cartModel.getItemCount() > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cartModel.getItemCount()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate how many columns based on screen width
                      // Max widget width 220, so on wider screens show more columns
                      int crossAxisCount = (constraints.maxWidth / 220).floor();
                      // Minimum 2 columns, maximum 4
                      crossAxisCount = crossAxisCount.clamp(2, 4);

                      return GridView.builder(
                        itemCount: shoes.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Shoesgrid(shoes: shoes[index]);
                        },
                      );
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