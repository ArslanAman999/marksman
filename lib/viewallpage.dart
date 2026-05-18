import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marksman/shoesgrid.dart';

import 'Shoes_data.dart';
import 'cartpage.dart';

class viewallpage extends StatefulWidget {
  const viewallpage({super.key});

  @override
  State<viewallpage> createState() => _viewallpageState();
}

class _viewallpageState extends State<viewallpage> {
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
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => cartpage(),)
                );
              },
              icon: Icon(Icons.shopping_cart),

            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal:25,vertical: 25),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color:Colors.grey[100],
                borderRadius:BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Search'),
                Icon(Icons.search),
              ],
            ),
          ),
          Expanded(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: shoesList.length,
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // items per row
                    childAspectRatio: 2 / 3,
                    // item bblock ratio
                    crossAxisSpacing: 10,
                    // Space between columns
                    mainAxisSpacing: 10,
                    // Space between rows
                  ),
                  itemBuilder: (context, index) {
                    return Shoesgrid(
                      shoes: shoesList[index], // Pass the current shoe object
                    );
                  },),
              ), ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        height: 25,
      ),
    );
  }
}
