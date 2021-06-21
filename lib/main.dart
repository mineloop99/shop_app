import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import './screens/product_detail_screen.dart';

import './screens/products_overview_screen.dart';
import './providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ProductsProvider(),
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          accentColor: Colors.deepOrange,
          primarySwatch: Colors.blue,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
      ),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
