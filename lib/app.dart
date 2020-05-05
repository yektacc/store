import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/checkout/delivery/delivery_page.dart';
import 'package:store/store/checkout/payment/payment_page.dart';
import 'package:store/store/home/home_page.dart';
import 'package:store/store/location/address/address_page.dart';
import 'package:store/store/login_register/login/login_page.dart';
import 'package:store/store/login_register/profile/profile_page.dart';
import 'package:store/store/login_register/register/register_page.dart';
import 'package:store/store/management/management_home_page.dart';
import 'package:store/store/management/manager_login_page.dart';
import 'package:store/store/management/model.dart';
import 'package:store/store/management/seller/shop_add_product_page.dart';
import 'package:store/store/management/seller/shop_create_product_page.dart';
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
              fontFamily: "IranSans",
              primaryColor: AppColors.main_color_mat,
              primarySwatch: Colors.green,
              textTheme: Theme
                  .of(context)
                  .textTheme
                  .apply(
                fontFamily: "IranSans",
                bodyColor: AppColors.text_main,
                displayColor: Colors.pink,
              )),
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

              case ManagementHomePage.routeName:
                return MaterialPageRoute(
                    builder: (context) => ManagementHomePage());
                break;

              case ManagerLoginPage.routeName:
                return MaterialPageRoute(
                    builder: (context) => ManagerLoginPage());

            /*  case ShopManagementPage.routeName:
                return MaterialPageRoute(
                    builder: (context) => ShopManagementPage());
                break;*/

            /* case ServiceManagementPage.routeName:
                return MaterialPageRoute(
                    builder: (context) => ServiceManagementPage());
                break;*/

              case AddressPage.routeName:
                return MaterialPageRoute(builder: (context) => AddressPage());
                break;

              case DeliveryPage.routeName:
                return MaterialPageRoute(builder: (context) => DeliveryPage());
                break;

              case PaymentPage.routeName:
                return MaterialPageRoute(builder: (context) => PaymentPage());
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

              case ShopAddProductsPage.routeName:
                final ShopIdentifier arg = settings.arguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return ShopAddProductsPage(
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
