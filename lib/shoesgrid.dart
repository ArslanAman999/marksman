import 'package:flutter/material.dart';
import 'Shoes.dart';
import 'cart_model.dart';

class Shoesgrid extends StatefulWidget {
  final Shoes shoes;

  Shoesgrid({Key? key, required this.shoes}) : super(key: key);

  @override
  State<Shoesgrid> createState() => _ShoesgridState();
}

class _ShoesgridState extends State<Shoesgrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        width: 200,
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15)),
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
                    color: Color.fromRGBO(0, 0, 0, 0.5),
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
              child: Text(
                widget.shoes.description,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            // price & name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(widget.shoes.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('\$${widget.shoes.price}'),
                    ),
                  ],
                ),
                // Add to cart button
                IconButton(
                  // Disable button entirely if out of stock
                  onPressed: widget.shoes.stockQuantity > 0
                      ? () {
                    setState(() {
                      cartModel.addToCart(widget.shoes);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.shoes.name} added to cart'),
                      ),
                    );
                  }
                      : null, // null disables the button
                  icon: Icon(
                    Icons.add_shopping_cart,
                    // Grey out the icon when out of stock
                    color: widget.shoes.stockQuantity > 0
                        ? null
                        : Colors.grey[400],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}