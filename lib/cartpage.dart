import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marksman/Home_Page.dart';
import 'package:marksman/cart_model.dart';
import 'send_cartItem_to_database.dart';

import 'Shoes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class cartpage extends StatefulWidget {
   cartpage({super.key});

  @override
  State<cartpage> createState() => _cartpageState();
}


class _cartpageState extends State<cartpage> {

  final FirestoreService send_ = FirestoreService();

  int calculateTotalPrice() {
    int total = 0;
    for (var shoe in cartModel.getCartItems()) {
      total += shoe.price as int;
      // Assuming price is a double in the Shoes model
    }
    return total;
  }

  List<String> getProductNames() {
    List<String> productNames = [];
    for (var shoe in cartModel.getCartItems()) {
      productNames.add(shoe.name);
    }
    return productNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDBD2E0),
      // TOP-APP-BAR
      appBar: AppBar(
        backgroundColor: Color(0xFFDBD2E0),
        //automaticallyImplyLeading: false,
        // Removes the back button
        title: Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children:[

            //logo
            Image.asset('assets/images/ourlogo.png',
              height: 45,
              color: Colors.black,),

            IconButton(
              onPressed: (){},
                icon: Icon(Icons.shopping_cart),
              color: Colors.black,
            ),

            ],),
      ),

      /////////////////////////cart items//////////////////////\
      body: ListView.builder(
          itemCount: cartModel.getItemCount(),
          itemBuilder: (context, index){
            var shoe = cartModel.getCartItems()[index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                margin: EdgeInsets.only(left: 25, right: 25),

                decoration: BoxDecoration(
                    color: Colors.grey[100],borderRadius:BorderRadius.circular(15)),
                child: Column(
                  children: [
                    ListTile(
                      leading:Image.asset(shoe.imagelocation),
                      title: Text(shoe.name),
                      subtitle: Text('${shoe.price}\$'),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              cartModel.removeFromCart(shoe);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${shoe.name} removed from cart'),
                              ),
                            );
                          },
                          icon: Icon(Icons.remove_shopping_cart),),
                    ),
                  ],
                ),
              ),
            );
          }),


      //botoom bar
    bottomNavigationBar: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(padding:  EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Total:\$${calculateTotalPrice()}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),),
          ),
          ElevatedButton(
            onPressed: () {
              //button press logic here
              showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Text('Confirm Purchase'),
                      content: Text('Do you want to confirm your purchase?'),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.of(context).pop(); //dialoge will close
                        },
                            child: Text("'NO"),
                        ),

                        TextButton(onPressed: () async{
                          // Yes button logic
                          // Get the current timestamp
                          DateTime now = DateTime.now();

                          // Collect product names, total price, and total number of products
                          List<String> productNames = getProductNames();
                          int totalPrice = calculateTotalPrice();
                          int totalQuantity = cartModel.getItemCount();

                          await FirebaseFirestore.instance.collection('cart').add({
                            'productNames': productNames,  // List of product names (array)
                            'totalQuantity': totalQuantity, // Total number of items
                            'totalPrice': totalPrice,          // Quantity (number)
                            'timestamp': now,             // Current timestamp
                          });

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => HomePage(),)
                          );
                          //Navigator.of(context).pop();

                          //clear cart
                          setState(() {
                            cartModel.getCartItems().clear(); // Directly clear the cart items list
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Your Order has been placed Successfully!",
                            style: TextStyle(color: Colors.black,),),
                            backgroundColor: Colors.blue[400],),
                          );
                        },
                            child: Text("YES"))
                      ],
                    );
                  }
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF002400), // Button background color
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ),
            child: Text(
              'BUY NOW',
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 18, // Font size
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
