import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String uriSegment) async {
    final uri =
        'https://identitytoolkit.googleapis.com/v1/accounts:$uriSegment?key=AIzaSyCsedS7rYsanQj4UFM_DKzv1etf6DyGxm4';
    try {
      final respone = await http.post(
        Uri.parse(uri),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responeData = json.decode(respone.body);
      if (responeData['error'] != null) {
        throw HttpException(responeData['error']['message']);
      }
      _token = responeData['idToken'];
      _userId = responeData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responeData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();
      final sharedPrefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate?.toIso8601String(),
        },
      );
      sharedPrefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (!sharedPrefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(sharedPrefs.getString('userData') as String)
            as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
