import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;
  final String? userId;
  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final uri = Uri.parse(
        'https://shop-app-ce2f1-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final respone = await http.get(uri);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(respone.body) as Map<String, dynamic>?;
    if (extractedData == null) return;
    extractedData.forEach((orderId, value) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: double.parse(value['amount']),
          products: (value['product'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    price: double.parse(item['price']),
                    title: item['title'],
                    quantity: item['quantity'],
                  ))
              .toList(),
          dateTime: DateTime.parse(value['dateTime'])));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final uri = Uri.parse(
        'https://shop-app-ce2f1-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    final respone = await http.post(uri,
        body: json.encode({
          'amount': total.toString(),
          'dateTime': timeStamp.toIso8601String(),
          'product': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price.toString(),
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(respone.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
