import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String? id;
  final String? productId;
  final int? quantity;
  final double? price;
  final String? title;

  const CartItem({
    this.id,
    this.productId,
    this.quantity,
    this.price,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        onDismissed: (direction) {
          Provider.of<Cart>(context).removeItem(productId!);
        },
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('are you sure you won\'t delete this?'),
                    content: Text(''),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('NO')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes')),
                    ],
                  ));
        },
        direction: DismissDirection.endToStart,
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        ),
        key: ValueKey(id),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(
                      child: Text('\$ $price'),
                    )),
              ),
              title: Text(title!),
              subtitle: Text('total \$ ${price! * quantity!}'),
              trailing: Text('$quantity x'),
            ),
          ),
        ));
  }
}
