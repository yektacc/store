import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/data_layer/centers/centers_repository.dart';
import 'package:store/data_layer/centers/service_repository.dart';
import 'package:store/data_layer/fcm/fcm_token_repository.dart';
import 'package:store/data_layer/management/create_product_repo.dart';
import 'package:store/data_layer/management/seller_request_repository.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/data_layer/tags/tag_item_repository.dart';
import 'package:store/data_layer/userpet/user_pet_repository.dart';
import 'package:store/services/adoption/adoption_bloc.dart';
import 'package:store/services/adoption/adoption_repository.dart';
import 'package:store/services/centers/centers_bloc.dart';
import 'package:store/services/chat/inbox_manager.dart';
import 'package:store/services/lost_pets/lost_pets_bloc.dart';
import 'package:store/services/lost_pets/lost_pets_repository.dart';
import 'package:store/store/info/info_client.dart';
import 'package:store/store/landing/landing_bloc.dart';
import 'package:store/store/location/address/address_bloc.dart';
import 'package:store/store/location/address/address_repository.dart';
import 'package:store/store/location/my_location/my_location_bloc.dart';
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
import 'package:store/store/management/management_bloc.dart';
import 'package:store/store/payment/coupon/coupon_bloc.dart';
import 'package:store/store/payment/coupon/coupon_repository.dart';
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
import 'package:store/store/structure/repository.dart';
import 'package:store/store/structure/structure_bloc.dart';
import 'package:store/store/userpet/user_pet_bloc.dart';

import 'app.dart';
import 'data_layer/ads/ads_repository.dart';
import 'data_layer/brands/brands_repository.dart';
import 'data_layer/cart/cart_repository.dart';
import 'data_layer/management/management_repository.dart';
import 'data_layer/netclient.dart';
import 'data_layer/order/save_order_repository.dart';
import 'data_layer/payment/delivery/delivery_price_repository.dart';
import 'data_layer/products/product_pictures_repository.dart';
import 'data_layer/products/products_count_in_category.dart';

Future main() async {
  Net net = Net();

  // repositories
  final ProductsRepository _productRepo = ProductsRepository(net);
  final SearchInteractor _searchInteractor = SearchInteractor();
  final StructureRepository _structureRepo = StructureRepository(net);
  final LoginRepository _loginInteractor = LoginRepository(net);
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
  final ManagementRepository _sellerRepo = ManagementRepository(net);
  final PreviousOrdersRepository _ordersRepo = PreviousOrdersRepository(net);
  final ManagementBloc _managementBloc = ManagementBloc(
      _sellerRepo, CreateProductRepository(), _ordersRepo, _fcmRepo);

  final SearchBloc _searchBloc =
  SearchBloc(_productRepo, _searchInteractor, _centersRepo);

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
  final UserPetRepository _userPetRepository = UserPetRepository(net);
  final UserPetBloc _userPetBloc =
  UserPetBloc(_userPetRepository, _loginStatusBloc);
  final LandingBloc _landingBloc = LandingBloc(_provinceBloc, _structureBloc);
  final CouponRepository _couponRepo = CouponRepository();
  final CouponBloc _couponBloc = CouponBloc(_couponRepo);

  final SellerRequestRepository _sellerRequestRepo =
  SellerRequestRepository(net);

  final InboxManager _inboxManager =
  InboxManager(_loginStatusBloc, _managementBloc, net);

  runApp(App([
    Provider<Net>.value(value: net),
    Provider<ProductsBloc>.value(value: _productsBloc),
    Provider<FilteredProductsBloc>.value(value: _filteredProductsBloc),
    Provider<SearchBloc>.value(value: _searchBloc),
    Provider<StructureBloc>.value(value: _structureBloc),
    Provider<LoginBloc>.value(value: _loginBloc),
    Provider<LoginStatusBloc>.value(value: _loginStatusBloc),
    Provider<ForgetPassBloc>.value(value: _forgetPassBloc),
    Provider<ProfileBloc>.value(value: _profileBloc),
    Provider<RegisterBloc>.value(value: _registerBloc),
    Provider<CartBloc>.value(value: _cartBloc),
    Provider<ProductDetailBloc>.value(value: _productDetailBloc),
    Provider<AddressBloc>.value(value: _addressBloc),
    Provider<ProvinceBloc>.value(value: _provinceBloc),
    Provider<MyLocationBloc>.value(value: _myLocationBloc),
    Provider<LostPetsBloc>.value(value: _lostPetsBloc),
    Provider<AdoptionPetsBloc>.value(value: _adoptionPetsBloc),
    Provider<CentersBloc>.value(value: _centersBloc),
    Provider<AddressBloc>.value(value: _addressBloc),
    Provider<BrandsBloc>.value(value: _brandsBloc),
    Provider<ManagementRepository>.value(value: _sellerRepo),
    Provider<ProductsCountRepository>.value(value: _countRepo),
    Provider<ProvinceRepository>.value(value: _provinceRepo),
    Provider<SpecialProductsRepository>.value(value: _bestSellerRepo),
    Provider<ServicesRepository>.value(value: _servicesRepository),
    Provider<LostPetsRepository>.value(value: _lostPetsRepo),
    Provider<AdsRepository>.value(value: _adsRepo),
    Provider<ProductDetailRepository>.value(value: _detailRepo),
    Provider<DeliveryPriceRepository>.value(value: _deliveryPostRepo),
    Provider<StructureRepository>.value(value: _structureRepo),
    Provider<TagsRepository>.value(value: _tagsRepository),
    Provider<CartRepository>.value(value: _cartRepo),
    Provider<OrderRepository>.value(value: _orderRepo),
    Provider<ProductPicturesRepository>.value(value: _picturesRepo),
    Provider<BrandsRepository>.value(value: _brandsRepository),
    Provider<CentersRepository>.value(value: _centersRepo),
    Provider<PreviousOrdersRepository>.value(value: _ordersRepo),
    Provider<SiteInfoRepository>.value(value: _siteInfoRepository),
    Provider<ProductsRepository>.value(value: _productRepo),
    Provider<FavoriteBloc>.value(value: _favoriteBloc),
    Provider<CommentsRepository>.value(value: _commentsRepo),
    Provider<ManagementBloc>.value(value: _managementBloc),
    Provider<UserPetBloc>.value(value: _userPetBloc),
    Provider<LandingBloc>.value(value: _landingBloc),
    Provider<CouponBloc>.value(value: _couponBloc),
    Provider<SellerRequestRepository>.value(value: _sellerRequestRepo),
    Provider<FcmTokenRepository>.value(value: _fcmRepo),
    Provider<InboxManager>.value(value: _inboxManager),
  ]));
}
