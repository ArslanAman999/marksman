import 'package:flutter/material.dart';
import 'package:marksman/Home_Page.dart';
import 'package:marksman/cart_model.dart';
import 'send_cartItem_to_database.dart';
import 'Shoes.dart';

class cartpage extends StatefulWidget {
  cartpage({super.key});

  @override
  State<cartpage> createState() => _cartpageState();
}

class _cartpageState extends State<cartpage> {

  // Tracks whether order is currently being sent
  // Used to show loading spinner on the YES button
  bool _isPlacingOrder = false;

  int calculateTotalPrice() {
    int total = 0;
    for (var shoe in cartModel.getCartItems()) {
      total += shoe.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDBD2E0),

      // TOP-APP-BAR
      appBar: AppBar(
        backgroundColor: Color(0xFFDBD2E0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/ourlogo.png',
                height: 45, color: Colors.black),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart),
              color: Colors.black,
            ),
          ],
        ),
      ),

      // CART ITEMS LIST
      body: cartModel.getItemCount() == 0
          ? Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
          itemCount: cartModel.getItemCount(),
          itemBuilder: (context, index) {
            var shoe = cartModel.getCartItems()[index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Image.asset(shoe.imagelocation),
                  title: Text(shoe.name),
                  subtitle: Text('\$${shoe.price}'),
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
                    icon: Icon(Icons.remove_shopping_cart),
                  ),
                ),
              ),
            );
          }),

      // BOTTOM BAR
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Total: \$${calculateTotalPrice()}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: cartModel.getItemCount() == 0
                  ? null // Disable button if cart is empty
                  : () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Confirm Purchase'),
                      content: Text(
                          'Do you want to confirm your purchase?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('NO'),
                        ),
                        StatefulBuilder(
                          // StatefulBuilder lets us update just
                          // the YES button state inside the dialog
                          builder: (context, setDialogState) {
                            return TextButton(
                              onPressed: _isPlacingOrder
                                  ? null
                                  : () async {
                                setDialogState(() {
                                  _isPlacingOrder = true;
                                });

                                // Get cart items before clearing
                                List<Shoes> items =
                                List.from(cartModel.getCartItems());

                                // Send order to MySQL via API
                                bool success =
                                await sendOrderToDatabase(items);

                                if (success) {
                                  // Clear the cart
                                  setState(() {
                                    cartModel.getCartItems().clear();
                                  });

                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage()),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Your order has been placed successfully!',
                                        style: TextStyle(
                                            color: Colors.black),
                                      ),
                                      backgroundColor:
                                      Colors.blue[400],
                                    ),
                                  );
                                } else {
                                  // Order failed
                                  setDialogState(() {
                                    _isPlacingOrder = false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Order failed. Please try again.',
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: _isPlacingOrder
                                  ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                                  : Text('YES'),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF002400),
                padding:
                EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'BUY NOW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}