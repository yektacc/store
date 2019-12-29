import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/centers/centers_repository.dart';
import 'package:store/data_layer/centers/service_repository.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/data_layer/tags/tag_item_repository.dart';
import 'package:store/services/adoption/adoption_bloc.dart';
import 'package:store/services/centers/centers_bloc.dart';
import 'package:store/services/lost_pets/lost_pets_bloc.dart';
import 'package:store/services/lost_pets/lost_pets_repository.dart';
import 'package:store/store/home/home_page.dart';
import 'package:store/store/info/info_client.dart';
import 'package:store/store/location/address/address_bloc.dart';
import 'package:store/store/location/my_location/my_location_bloc.dart';
import 'package:store/store/location/provinces/provinces_bloc.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_bloc.dart';
import 'package:store/store/login_register/login/login_bloc.dart';
import 'package:store/store/login_register/login/login_page.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/profile/profile_bloc.dart';
import 'package:store/store/login_register/profile/profile_page.dart';
import 'package:store/store/login_register/register/register_bloc.dart';
import 'package:store/store/login_register/register/register_page.dart';
import 'package:store/store/products/brands/brands_bloc.dart';
import 'package:store/store/products/cart/cart_bloc.dart';
import 'package:store/store/products/cart/cart_page.dart';
import 'package:store/store/products/comments/comments_repository.dart';
import 'package:store/store/products/detail/product_detail_bloc.dart';
import 'package:store/store/products/detail/product_detail_page.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';
import 'package:store/store/products/favorites/favorites_bloc.dart';
import 'package:store/store/products/filter/filtered_products_bloc.dart';
import 'package:store/store/products/product/products_bloc.dart';
import 'package:store/store/products/product/products_page.dart';
import 'package:store/store/products/product/products_repository.dart';
import 'package:store/store/products/search/search_bloc.dart';
import 'package:store/store/products/special/special_products_repository.dart';
import 'package:store/store/shop_management/create_product_page.dart';
import 'package:store/store/shop_management/seller_add_product_page.dart';
import 'package:store/store/shop_management/seller_list_page.dart';
import 'package:store/store/shop_management/shop_management_bloc.dart';
import 'package:store/store/structure/repository.dart';
import 'package:store/store/structure/structure_bloc.dart';

import 'data_layer/ads/ads_repository.dart';
import 'data_layer/brands/brands_repository.dart';
import 'data_layer/cart/cart_repository.dart';
import 'data_layer/order/save_order_repository.dart';
import 'data_layer/payment/delivery/delivery_price_repository.dart';
import 'data_layer/products/product_pictures_repository.dart';
import 'data_layer/products/products_count_in_category.dart';
import 'data_layer/shop_management/shop_repository.dart';
import 'landing_page.dart';

class App extends StatefulWidget {
  final ProductsBloc _productsBloc;
  final FilteredProductsBloc _filteredProductsBloc;
  final SearchBloc _searchBloc;
  final StructureBloc _structureBloc;
  final LoginBloc _loginBloc;
  final LoginStatusBloc _loginStatusBloc;
  final ForgetPassBloc _forgetPassBloc;
  final ProfileBloc _profileBloc;
  final RegisterBloc _registerBloc;
  final CartBloc _cartBloc;
  final AddressBloc _addressBloc;
  final ProductDetailBloc _detailBloc;
  final MyLocationBloc _myLocationBloc;
  final ProvinceBloc _provincesBloc;
  final LostPetsBloc _lostPetsBloc;
  final AdoptionPetsBloc _adoptionPetsBloc;
  final CentersBloc _centersBloc;
  final BrandsBloc _brandsBloc;

  // repos
  final ShopRepository _sellerRepo;
  final ProductsCountRepository _countRepo;
  final ProvinceRepository _provinceRepo;
  final SpecialProductsRepository _bestSellerRepo;
  final ServicesRepository _servicesRepo;
  final LostPetsRepository _lostPetsRepo;
  final AdsRepository _adsRepository;
  final ProductDetailRepository _detailRepository;
  final DeliveryPriceRepository _deliveryPriceRepository;
  final StructureRepository _structureRepository;
  final TagsRepository _tagsRepository;
  final CartRepository _cartRepository;
  final OrderRepository _orderRepository;
  final ProductPicturesRepository _picturesRepo;
  final BrandsRepository _brandsRepo;
  final CentersRepository _centersRepo;
  final OrdersRepository _prvOrderRepository;
  final SiteInfoRepository _siteInfoRepository;
  final ProductsRepository _productsRepository;
  final FavoriteBloc _favoriteBloc;
  final CommentsRepository _commentsRepo;
  final ShopManagementBloc _shopBloc;

  App(
      this._productsBloc,
      this._filteredProductsBloc,
      this._searchBloc,
      this._structureBloc,
      this._loginBloc,
      this._loginStatusBloc,
      this._forgetPassBloc,
      this._profileBloc,
      this._registerBloc,
      this._cartBloc,
      this._detailBloc,
      this._addressBloc,
      this._provincesBloc,
      this._myLocationBloc,
      this._lostPetsBloc,
      this._adoptionPetsBloc,
      this._centersBloc,
      this._brandsBloc,
      this._sellerRepo,
      this._countRepo,
      this._provinceRepo,
      this._bestSellerRepo,
      this._servicesRepo,
      this._lostPetsRepo,
      this._adsRepository,
      this._detailRepository,
      this._deliveryPriceRepository,
      this._structureRepository,
      this._tagsRepository,
      this._cartRepository,
      this._orderRepository,
      this._picturesRepo,
      this._brandsRepo,
      this._centersRepo,
      this._prvOrderRepository,
      this._siteInfoRepository,
      this._productsRepository,
      this._favoriteBloc,
      this._commentsRepo,
      this._shopBloc);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return new MultiProvider(
        providers: [
          Provider<ProductsBloc>.value(value: widget._productsBloc),
          Provider<FilteredProductsBloc>.value(
              value: widget._filteredProductsBloc),
          Provider<SearchBloc>.value(value: widget._searchBloc),
          Provider<StructureBloc>.value(value: widget._structureBloc),
          Provider<LoginBloc>.value(value: widget._loginBloc),
          Provider<LoginStatusBloc>.value(value: widget._loginStatusBloc),
          Provider<ForgetPassBloc>.value(value: widget._forgetPassBloc),
          Provider<ProfileBloc>.value(value: widget._profileBloc),
          Provider<RegisterBloc>.value(value: widget._registerBloc),
          Provider<CartBloc>.value(value: widget._cartBloc),
          Provider<ProductDetailBloc>.value(value: widget._detailBloc),
          Provider<AddressBloc>.value(value: widget._addressBloc),
          Provider<ProvinceBloc>.value(value: widget._provincesBloc),
          Provider<MyLocationBloc>.value(value: widget._myLocationBloc),
          Provider<LostPetsBloc>.value(value: widget._lostPetsBloc),
          Provider<AdoptionPetsBloc>.value(value: widget._adoptionPetsBloc),
          Provider<CentersBloc>.value(value: widget._centersBloc),
          Provider<AddressBloc>.value(value: widget._addressBloc),
          Provider<BrandsBloc>.value(value: widget._brandsBloc),
          Provider<ShopRepository>.value(value: widget._sellerRepo),
          Provider<ProductsCountRepository>.value(value: widget._countRepo),
          Provider<ProvinceRepository>.value(value: widget._provinceRepo),
          Provider<SpecialProductsRepository>.value(
              value: widget._bestSellerRepo),
          Provider<ServicesRepository>.value(value: widget._servicesRepo),
          Provider<LostPetsRepository>.value(value: widget._lostPetsRepo),
          Provider<AdsRepository>.value(
            value: widget._adsRepository,
          ),
          Provider<ProductDetailRepository>.value(
            value: widget._detailRepository,
          ),
          Provider<DeliveryPriceRepository>.value(
              value: widget._deliveryPriceRepository),
          Provider<StructureRepository>.value(
              value: widget._structureRepository),
          Provider<TagsRepository>.value(value: widget._tagsRepository),
          Provider<CartRepository>.value(value: widget._cartRepository),
          Provider<OrderRepository>.value(value: widget._orderRepository),
          Provider<ProductPicturesRepository>.value(
              value: widget._picturesRepo),
          Provider<BrandsRepository>.value(value: widget._brandsRepo),
          Provider<CentersRepository>.value(value: widget._centersRepo),
          Provider<OrdersRepository>.value(
              value: widget._prvOrderRepository),
          Provider<SiteInfoRepository>.value(value: widget._siteInfoRepository),
          Provider<ProductsRepository>.value(value: widget._productsRepository),
          Provider<FavoriteBloc>.value(value: widget._favoriteBloc),
          Provider<CommentsRepository>.value(value: widget._commentsRepo),
          Provider<ShopManagementBloc>.value(value: widget._shopBloc),
        ],
        child: MaterialApp(
          title: 'epet24',
          theme: ThemeData(
              primaryColor: AppColors.main_color,
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

              case SellersListPage.routeName:
                return MaterialPageRoute(
                    builder: (context) => SellersListPage());
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
