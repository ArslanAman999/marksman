import 'Shoes.dart';

class CartItem {
  final Shoes shoe;
  int quantity;

  CartItem({required this.shoe, this.quantity = 1});
}

class CartModel {
  // Stores cart items as a map: shoe id → CartItem
  // This automatically handles duplicates by incrementing quantity
  final Map<int, CartItem> _cartItems = {};

  // Add shoe to cart
  // If already exists, increment quantity
  void addToCart(Shoes shoe) {
    if (_cartItems.containsKey(shoe.id)) {
      _cartItems[shoe.id]!.quantity++;
    } else {
      _cartItems[shoe.id] = CartItem(shoe: shoe);
    }
  }

  // Remove one quantity of a shoe
  // If quantity reaches 0, remove entirely
  void removeFromCart(Shoes shoe) {
    if (_cartItems.containsKey(shoe.id)) {
      if (_cartItems[shoe.id]!.quantity > 1) {
        _cartItems[shoe.id]!.quantity--;
      } else {
        _cartItems.remove(shoe.id);
      }
    }
  }

  // Returns list of CartItems for display
  List<CartItem> getCartItems() {
    return _cartItems.values.toList();
  }

  // Total number of individual items (not unique shoes)
  int getItemCount() {
    int total = 0;
    for (var item in _cartItems.values) {
      total += item.quantity;
    }
    return total;
  }

  // Total price
  int getTotalPrice() {
    int total = 0;
    for (var item in _cartItems.values) {
      total += item.shoe.price * item.quantity;
    }
    return total;
  }

  void clearCart() {
    _cartItems.clear();
  }
}

final cartModel = CartModel();