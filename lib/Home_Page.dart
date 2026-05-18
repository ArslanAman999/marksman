import 'package:flutter/cupertino.dart';
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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFDBD2E0),
      // TOP-APP-BAR
      appBar: AppBar(
        backgroundColor: Color(0xFFDBD2E0),
        automaticallyImplyLeading: false,  // Removes the back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
          //Account-Profile icon
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => profilepage()));
              },
              iconSize: 35,
              icon: Icon(Icons.account_circle)),

        //mid-logo
            Image.asset('assets/images/ourlogo.png',
              height: 45,
            color: Colors.black,),

        //Size chart icon
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SizeChartPage(),)
                );
              },
              iconSize: 30,
              icon: Icon(Icons.straighten)),
        ],),

      ),
      
      body: Column(
        children: [
          // seartch bar
          Container(
            margin: EdgeInsets.symmetric(horizontal:15,vertical: 15),
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


          Text('Hit the Mark',style: TextStyle(
            color: Color(0xFFB5AFC1),
            fontSize: 12.5,
          ),),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('HOT PICKS 🔥',
                  style: TextStyle(
                    fontSize:15, fontWeight: FontWeight.bold),),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>viewallpage(),));
                    },
                    child: Text('View All'),),
              ),
            ],
          ),

          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                  // shoe item creation
                      Shoes shoes = shoesList[index]; // Fetch each shoe

                      return Shoesgrid(shoes: shoes);

                      return Shoesgrid(shoes: shoes);
                }),
              )
          ),

        ],
      ),

      /////////////////////////////////////////////////////////////////////
      //BOTTOM-APP-BAR
    bottomNavigationBar: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Home-icon
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: (){},
              iconSize: 35,
                color: Color(0xFF002400),
              icon: Icon(Icons.home),
             // iconSize: currentpage == 0?35:null,
            ),
          ),

          //CART-ICON
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => cartpage(),)
                  );
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

