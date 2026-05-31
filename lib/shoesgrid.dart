import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'Shoes.dart';
import 'cart_model.dart';
import 'cartpage.dart';

class Shoesgrid extends StatefulWidget {
  final Shoes shoes; // Changed to final

  Shoesgrid({Key? key, required this.shoes}) : super(key: key);

  @override
  State<Shoesgrid> createState() => _ShoesgridState();
}

class _ShoesgridState extends State<Shoesgrid> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        width: 200,
        decoration: BoxDecoration(
            color: Colors.grey[100],borderRadius:BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // image
            Padding(
              padding: const EdgeInsets.all(5.0),
             child: widget.shoes.stockQuantity > 0
    ? Image.asset(widget.shoes.imagelocation)
    : Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(widget.shoes.imagelocation),
          Container(
            color: Colors.black.withOpacity(0.5),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'OUT OF STOCK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
            ),

            // description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.shoes.description,
                style: TextStyle(
                  color: Colors.grey
                ),),
            ),

            //price&Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    //name
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(widget.shoes.name,style:
                      TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    //proce
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('\$${widget.shoes.price}',),
                    ),
                  ],
                ),
                //Add to cartbutton
                IconButton(
                    onPressed: (){
                      setState(() {
                        cartModel.addToCart(widget.shoes); // Add the item to the cart
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.shoes.name} added to cart'),
                        ),
                      );
                    },
                    icon: Icon(Icons.add_shopping_cart))
              ],
            )


          ],
        ),
      ),
    );
  }
}
