import 'package:mongo_dart/mongo_dart.dart';
import 'package:http/http.dart' as http;

void start() async {
  final db = await Db.create(
      'mongodb+srv://mine-loop:Hungthjkju2@shopapptesting.ys7hr.mongodb.net/my_shop_app?retryWrites=true&w=majority');
  await db.open();
  print('Connected to db');
  final coll = db.collection('products').find().toList();

  var products = await coll;
}
