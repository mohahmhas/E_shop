import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_ec/providers/auth.dart';
import 'package:shop_app_ec/providers/cart.dart';
import 'package:shop_app_ec/providers/product.dart';
import 'package:shop_app_ec/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
          child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id),
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              )),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
                builder: ((context, product, _) => IconButton(
                      onPressed: () {
                        product.toggleFavoriteStatus(
                            authData.token, authData.userId);
                      },
                      icon: Icon(product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border),
                      color: Colors.purple,
                    ))),
            title: Text(product.title),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('this produect\'s add in cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo!',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
              },
            ),
          ),
        ));
  }
}
