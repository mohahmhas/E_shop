import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrederScreen extends StatelessWidget {
  static const routeName = '/orederScreen';
  const OrederScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text('your Order')),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetProducts(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('an error occurred!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (context, index) => OrderItem()),
                );
              }
            }
          },
        ));
  }
}
