import 'Shoes.dart';

class CartModel {
  // A list to store added shoes
  List<Shoes> _cartItems = [];

  // Function to add shoes to the cart
  void addToCart(Shoes shoe) {
    _cartItems.add(shoe);
  }

  // Function to get the list of cart items
  List<Shoes> getCartItems() {
    return _cartItems;
  }

  // Function to get the total count of items in the cart
  int getItemCount() {
    return _cartItems.length;
  }

  // Function to remove items from the cart
  void removeFromCart(Shoes shoe) {
    _cartItems.remove(shoe);
  }
}

// Create a global CartModel instance that will be used across all pages
final cartModel = CartModel();
