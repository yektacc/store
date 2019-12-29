import 'package:flutter/material.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:store/data_layer/centers/centers_repository.dart';
import 'package:store/data_layer/centers/service_repository.dart';
import 'package:store/data_layer/fcm/fcm_token_repository.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/data_layer/shop_management/create_product_repo.dart';
import 'package:store/data_layer/tags/tag_item_repository.dart';
import 'package:store/services/adoption/adoption_bloc.dart';
import 'package:store/services/adoption/adoption_repository.dart';
import 'package:store/services/centers/centers_bloc.dart';
import 'package:store/services/chat/chat_bloc.dart';
import 'package:store/services/chat/chat_page.dart';
import 'package:store/services/chat/model.dart';
import 'package:store/services/lost_pets/lost_pets_bloc.dart';
import 'package:store/services/lost_pets/lost_pets_repository.dart';
import 'package:store/store/info/info_client.dart';
import 'package:store/store/location/address/address_bloc.dart';
import 'package:store/store/location/address/address_repository.dart';
import 'package:store/store/location/my_location/my_location_bloc.dart';
import 'package:store/store/location/provinces/model.dart';
import 'package:store/store/location/provinces/provinces_bloc.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_bloc.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_interactor.dart';
import 'package:store/store/login_register/login/login_bloc.dart';
import 'package:store/store/login_register/login/login_interactor.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/profile/profile_bloc.dart';
import 'package:store/store/login_register/profile/profile_repository.dart';
import 'package:store/store/login_register/register/register_bloc.dart';
import 'package:store/store/login_register/register/register_interactor.dart';
import 'package:store/store/products/brands/brands_bloc.dart';
import 'package:store/store/products/cart/cart_bloc.dart';
import 'package:store/store/products/comments/comments_repository.dart';
import 'package:store/store/products/detail/product_detail_bloc.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';
import 'package:store/store/products/favorites/favorite_repository.dart';
import 'package:store/store/products/favorites/favorites_bloc.dart';
import 'package:store/store/products/filter/filtered_products_bloc.dart';
import 'package:store/store/products/product/products_bloc.dart';
import 'package:store/store/products/product/products_repository.dart';
import 'package:store/store/products/search/search_bloc.dart';
import 'package:store/store/products/search/search_interactor.dart';
import 'package:store/store/products/special/special_products_repository.dart';
import 'package:store/store/shop_management/shop_management_bloc.dart';
import 'package:store/store/structure/repository.dart';
import 'package:store/store/structure/structure_bloc.dart';

import 'data_layer/ads/ads_repository.dart';
import 'data_layer/brands/brands_repository.dart';
import 'data_layer/cart/cart_repository.dart';
import 'data_layer/netclient.dart';
import 'data_layer/order/save_order_repository.dart';
import 'data_layer/payment/delivery/delivery_price_repository.dart';
import 'data_layer/products/product_pictures_repository.dart';
import 'data_layer/products/products_count_in_category.dart';
import 'data_layer/shop_management/shop_repository.dart';

Future main() async {
  print(PersianDateTime()
      .add(Duration(days: 1))
      .jalaaliDay); //  var res = await repo.fetch();

/*  ProductPicturesRepo repo = ProductPicturesRepo(net);
  var res = await repo.fetch(1);*/

/*

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
        primaryColor: Colors.red,
        fontFamily: "IranSans",
        textTheme: TextTheme(body1: TextStyle(fontSize: 13))),
    supportedLocales: [
      Locale("fa", "IR"),
    ],
    locale: Locale("fa", "IR"),
    home: Text("adsf"),
  ));*/
  Net net = Net();

  final ProductsRepository _productRepo = ProductsRepository(net);
  final SearchInteractor _searchInteractor = SearchInteractor();
  final StructureRepository _structureRepo = StructureRepository(net);
  final LoginInteractor _loginInteractor = LoginInteractor(net);
  final RegisterInteractor _registerInteractor = RegisterInteractor(net);
  final ProfileRepository _profileRepo = ProfileRepository(net);
  final ProductDetailRepository _detailRepo = ProductDetailRepository(net);
  final ProvinceRepository _provinceRepo = ProvinceRepository(net);
  final AdoptionPetsRepository _adoptionPetsRepo = AdoptionPetsRepository();
  final ForgetPassInteractor _forgetPassInteractor = ForgetPassInteractor(net);
  final BrandsRepository _brandsRepository = BrandsRepository(net);
  final ProductsBloc _productsBloc = ProductsBloc(_productRepo);
  final FilteredProductsBloc _filteredProductsBloc =
      FilteredProductsBloc(_productsBloc);
  final SearchBloc _searchBloc = SearchBloc(_productRepo, _searchInteractor);
  final StructureBloc _structureBloc = StructureBloc(_structureRepo);
  final CartBloc _cartBloc = CartBloc(_detailRepo);
  final RegisterBloc _registerBloc = RegisterBloc(_registerInteractor);
  final LoginBloc _loginBloc = LoginBloc(_loginInteractor, _registerBloc);
  final FcmTokenRepository _fcmRepo = FcmTokenRepository(net);
  final LoginStatusBloc _loginStatusBloc =
  LoginStatusBloc(_loginBloc, _fcmRepo);
  final ProfileBloc _profileBloc = ProfileBloc(_profileRepo, _loginStatusBloc);
  final ProductDetailBloc _productDetailBloc = ProductDetailBloc(_detailRepo);
  final ProvinceBloc _provinceBloc = ProvinceBloc(_provinceRepo);
  final MyLocationBloc _myLocationBloc = MyLocationBloc();
  final LostPetsRepository _lostPetsRepo =
      LostPetsRepository(_provinceRepo, net);
  final LostPetsBloc _lostPetsBloc = LostPetsBloc(_lostPetsRepo);
  final AdoptionPetsBloc _adoptionPetsBloc =
      AdoptionPetsBloc(_adoptionPetsRepo);
  final ForgetPassBloc _forgetPassBloc = ForgetPassBloc(_forgetPassInteractor);
  final BrandsBloc _brandsBloc = BrandsBloc(_brandsRepository);

  // repository
  final AddressRepository _addressRepo = AddressRepository(net);
  final AddressBloc _addressBloc = AddressBloc(_addressRepo);
  final CentersRepository _centersRepo = CentersRepository(_provinceRepo, net);
  final CentersBloc _centersBloc = CentersBloc(_centersRepo);
  final ShopRepository _sellerRepo = ShopRepository(net);
  final OrdersRepository _ordersRepo = OrdersRepository(net);
  final ShopManagementBloc _shopBloc =
  ShopManagementBloc(_sellerRepo, CreateProductRepository(), _ordersRepo);

  final ProductsCountRepository _countRepo =
      ProductsCountRepository(_productRepo, _structureBloc);
  final SpecialProductsRepository _bestSellerRepo =
  SpecialProductsRepository(net);
  final ServicesRepository _servicesRepository = ServicesRepository(net);
  final AdsRepository _adsRepo = AdsRepository(net);
  final DeliveryPriceRepository _deliveryPostRepo =
      DeliveryPriceRepository(net);
  final TagsRepository _tagsRepository = TagsRepository(net, _detailRepo);

  final OrderRepository _orderRepo = OrderRepository(net);

  final CartRepository _cartRepo = CartRepository(net, _detailRepo);
  final ProductPicturesRepository _picturesRepo =
      ProductPicturesRepository(net);

  final SiteInfoRepository _siteInfoRepository = SiteInfoRepository(net);
  final FavoriteBloc _favoriteBloc = FavoriteBloc(
      _loginStatusBloc, FavoriteRepository(_detailRepo), _detailRepo);
  final CommentsRepository _commentsRepo = CommentsRepository(net);

  bool initResult = await init(_provinceRepo);

  if (initResult == true) {
    runApp(
      /*App(
        _productsBloc,
        _filteredProductsBloc,
        _searchBloc,
        _structureBloc,
        _loginBloc,
        _loginStatusBloc,
        _forgetPassBloc,
        _profileBloc,
        _registerBloc,
        _cartBloc,
        _productDetailBloc,
        _addressBloc,
        _provinceBloc,
        _myLocationBloc,
        _lostPetsBloc,
        _adoptionPetsBloc,
        _centersBloc,
        _brandsBloc,
        _sellerRepo,
        _countRepo,
        _provinceRepo,
        _bestSellerRepo,
        _servicesRepository,
        _lostPetsRepo,
        _adsRepo,
        _detailRepo,
        _deliveryPostRepo,
        _structureRepo,
        _tagsRepository,
        _cartRepo,
        _orderRepo,
        _picturesRepo,
        _brandsRepository,
        _centersRepo,
        _ordersRepo,
        _siteInfoRepository,
        _productRepo,
        _favoriteBloc,
        _commentsRepo,_shopBloc)*/
        MaterialApp(home: ChatPage(
            ChatBloc(ClientChatUser('09359236524'), ClinicChatUser('20'))),));
  }
}

Future<bool> init(ProvinceRepository _provinceRepo) async {
  List<Province> prvs = await _provinceRepo.getAllAsync();
  return prvs.isNotEmpty;
}
