import 'package:flutter/material.dart';
import 'package:marksman/Home_Page.dart';
import 'package:marksman/cart_model.dart';
import 'send_cartItem_to_database.dart';

class cartpage extends StatefulWidget {
  cartpage({super.key});

  @override
  State<cartpage> createState() => _cartpageState();
}

class _cartpageState extends State<cartpage> {

  bool _isPlacingOrder = false;

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
        // itemCount is now number of unique shoes not total quantity
          itemCount: cartModel.getCartItems().length,
          itemBuilder: (context, index) {
            var cartItem = cartModel.getCartItems()[index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Image.asset(cartItem.shoe.imagelocation),
                  title: Text(cartItem.shoe.name),
                  // Shows price x quantity = subtotal
                  subtitle: Text(
                    '\$${cartItem.shoe.price} x ${cartItem.quantity}  =  \$${cartItem.shoe.price * cartItem.quantity}',
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        cartModel.removeFromCart(cartItem.shoe);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${cartItem.shoe.name} removed from cart'),
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
                // Uses CartModel's getTotalPrice() instead of manual calc
                'Total: \$${cartModel.getTotalPrice()}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: cartModel.getItemCount() == 0
                  ? null
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
                          builder: (context, setDialogState) {
                            return TextButton(
                              onPressed: _isPlacingOrder
                                  ? null
                                  : () async {
                                setDialogState(() {
                                  _isPlacingOrder = true;
                                });

                                // Get CartItems list
                                List<CartItem> items =
                                List.from(cartModel.getCartItems());

                                // Send order to API
                                int orderId =
                                await sendOrderToDatabase(items);

                                if (orderId != -1) {
                                  // Clear cart properly
                                  setState(() {
                                    cartModel.clearCart();
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
                                      duration:
                                      Duration(seconds: 6),
                                      backgroundColor:
                                      Colors.blue[400],
                                      content: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            'Order #$orderId placed!',
                                            style: TextStyle(
                                                color:
                                                Colors.black),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              bool cancelled =
                                              await cancelOrder(
                                                  orderId);
                                              if (cancelled) {
                                                ScaffoldMessenger
                                                    .of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Order #$orderId cancelled'),
                                                    backgroundColor:
                                                    Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              'CANCEL ORDER',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
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