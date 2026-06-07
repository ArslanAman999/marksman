import 'package:flutter/material.dart';
import 'Shoes.dart';

class CartItem {
  final Shoes shoe;
  int quantity;

  CartItem({required this.shoe, this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  final Map<int, CartItem> _cartItems = {};

  void addToCart(Shoes shoe) {
    if (_cartItems.containsKey(shoe.id)) {
      _cartItems[shoe.id]!.quantity++;
    } else {
      _cartItems[shoe.id] = CartItem(shoe: shoe);
    }
    notifyListeners();
  }

  void removeFromCart(Shoes shoe) {
    if (_cartItems.containsKey(shoe.id)) {
      if (_cartItems[shoe.id]!.quantity > 1) {
        _cartItems[shoe.id]!.quantity--;
      } else {
        _cartItems.remove(shoe.id);
      }
    }
    notifyListeners();
  }

  List<CartItem> getCartItems() {
    return _cartItems.values.toList();
  }

  int getItemCount() {
    int total = 0;
    for (var item in _cartItems.values) {
      total += item.quantity;
    }
    return total;
  }

  int getTotalPrice() {
    int total = 0;
    for (var item in _cartItems.values) {
      total += item.shoe.price * item.quantity;
    }
    return total;
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

final cartModel = CartModel();