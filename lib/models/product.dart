import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final uri = Uri.parse(
        'https://shop-app-ce2f1-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token');
    try {
      final respone = await http.patch(uri,
          body: json.encode({
            id: isFavorite,
          }));
      if (respone.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
    }
  }
}
