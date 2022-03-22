import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_ec/providers/auth.dart';
import 'package:shop_app_ec/providers/cart.dart';
import 'package:shop_app_ec/providers/orders.dart';

import 'package:shop_app_ec/providers/products.dart';
import 'package:shop_app_ec/screens/cart_screen.dart';
import 'package:shop_app_ec/screens/edit_product_screen.dart';
import 'package:shop_app_ec/screens/orders_screen.dart';
import 'package:shop_app_ec/screens/product_detail_screen.dart';
import 'package:shop_app_ec/screens/product_overview_screen.dart';
import 'package:shop_app_ec/screens/user_products_screen.dart';
import './screens/splash_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (ctx, authValue, previousOrders) => previousOrders!
            ..getData(
                authValue.token!, authValue.userId!, previousOrders.orders),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProduct) => previousProduct!
            ..getData(
                authValue.token!, authValue.userId!, previousProduct.items),
        ),
        ChangeNotifierProvider.value(value: Products()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: Colors.purple),
            ),
            fontFamily: 'Lato',
            primarySwatch: Colors.purple,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, AsyncSnapshot authSnapShot) {
                    return authSnapShot.connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen();
                  },
                ),
          routes: {
            ProductOverviewScreen.routeName: (context) =>
                ProductOverviewScreen(),
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrederScreen.routeName: (context) => OrederScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductsScreen.routeName: (context) => EditProductsScreen(),
          },
        ),
      ),
    );
  }
}
