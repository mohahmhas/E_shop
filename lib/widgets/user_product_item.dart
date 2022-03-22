import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_ec/providers/product.dart';
import 'package:shop_app_ec/providers/products.dart';
import 'package:shop_app_ec/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String? id;
  final String? titel;
  final String? imageUrl;
  const UserProductItem({this.id, this.titel, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(titel!),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl!),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductsScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deletProduct(id!);
                } catch (e) {
                  ScaffoldMessenger(
                      child: SnackBar(content: Text('delete is failed!')));
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
