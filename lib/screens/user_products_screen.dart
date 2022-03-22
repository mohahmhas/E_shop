import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/userProductsScreen';
  const UserProductsScreen({Key? key}) : super(key: key);
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('your Product'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                    EditProductsScreen.routeName,
                  ),
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, AsyncSnapshot snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (ctx, index) => Column(
                                  children: [
                                    UserProductItem(
                                        id: productsData.items[index].id,
                                        titel: productsData.items[index].title,
                                        imageUrl:
                                            productsData.items[index].imageUrl),
                                    Divider(),
                                  ],
                                )),
                      ),
                    ),
                    onRefresh: () => _refreshProducts(context)),
      ),
    );
  }
}
