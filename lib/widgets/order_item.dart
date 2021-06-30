import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('Total: \$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 10, 100)
                  : 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              child: ListView(
                children: widget.order.products
                    .map(
                      (e) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total: ${e.quantity}x \$${e.price}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
