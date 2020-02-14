import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/home/home_page.dart';
import 'package:store/store/login_register/login/login_page.dart';
import 'package:store/store/login_register/profile/profile_page.dart';
import 'package:store/store/login_register/register/register_page.dart';
import 'package:store/store/management/model.dart';
import 'package:store/store/management/service/service_management_page.dart';
import 'package:store/store/management/shop/create_product_page.dart';
import 'package:store/store/management/shop/seller_add_product_page.dart';
import 'package:store/store/management/shop/shop_management_page.dart';
import 'package:store/store/products/cart/cart_page.dart';
import 'package:store/store/products/detail/product_detail_page.dart';
import 'package:store/store/products/product/products_page.dart';

import 'store/landing/landing_page.dart';

class App extends StatefulWidget {
  final List<Provider> providers;

  App(this.providers);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return new MultiProvider(
        providers: widget.providers,
        child: MaterialApp(
          title: 'epet24',
          theme: ThemeData(
              primaryColor: AppColors.second_color,
              primarySwatch: Colors.red,
              fontFamily: "IranSans",
              textTheme: TextTheme(body1: TextStyle(fontSize: 13))),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            Locale("fa", "IR"),
          ],
          locale: Locale("fa", "IR"),
          home: LandingPage(),
          onGenerateRoute: (settings) {
            // If you push the PassArguments route
            switch (settings.name) {
              case ProductDetailPage.routeName:
                final DetailPageArgs args = settings.arguments;

                // Then, extract the required data from the arguments and
                // pass the data to the correct screen.
                return MaterialPageRoute(
                  builder: (context) {
                    return ProductDetailPage(
                      productId: args.productId,
                      initialSellerId: args.initialSellerId,
                      imgUrl: args.img,
                      brand: args.brand,
                    );
                  },
                );
                break;

              case ProfilePage.routeName:
                return MaterialPageRoute(builder: (context) => ProfilePage());
                break;

              case CartPage.routeName:
                return MaterialPageRoute(builder: (context) => CartPage());
                break;

              case HomePage.routeName:
                return MaterialPageRoute(builder: (context) => HomePage());
                break;

              case ProductsPage.routeName:
                return MaterialPageRoute(builder: (context) => ProductsPage());
                break;

              case ShopManagementPage.routeName:
                return MaterialPageRoute(
                    builder: (context) => ShopManagementPage());
                break;

              case ServiceManagementPage.routeName:
                return MaterialPageRoute(
                    builder: (context) => ServiceManagementPage());
                break;

              case CreateProductPage.routeName:
                final ShopIdentifier arg = settings.arguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return CreateProductPage(
                      shop: arg,
                    );
                  },
                );
                break;

              case SellerAddProductsPage.routeName:
                final ShopIdentifier arg = settings.arguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return SellerAddProductsPage(
                      shop: arg,
                    );
                  },
                );
                break;

              default:
                return null;
            }
          },
        ));
  }
}

// page routes

class AppRoutes {
  /*static MaterialPageRoute productsPage(
          BuildContext context, Identifier identifier) =>
      MaterialPageRoute(builder: (context) => ProductsPage());*/

/*  static MaterialPageRoute productDetailPage(
          BuildContext context, ExtendedProduct product) =>
      MaterialPageRoute(builder: (context) => ProductDetailPage(product));*/

  /* static MaterialPageRoute cartPage(BuildContext context) =>
      MaterialPageRoute(builder: (context) => CartPage());*/

  static MaterialPageRoute loginPage(BuildContext context) {
    return MaterialPageRoute(builder: (context) => LoginPage());
  }

  static MaterialPageRoute registerPage(BuildContext context) =>
      MaterialPageRoute(builder: (context) => RegisterPage());

/*  static MaterialPageRoute homePage(BuildContext context) =>
      MaterialPageRoute(builder: (context) => HomePage());*/
}

class FcmHandler {
  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }
}
