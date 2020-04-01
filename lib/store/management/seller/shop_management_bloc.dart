import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/data_layer/management/management_repository.dart';
import 'package:store/store/management/model.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';

import 'shop_management_event_state.dart';

class ShopManagementBloc extends Bloc<ShopManagerEvent, ShopManagerState> {
  final ManagementRepository _managementRepo;
  final ProductDetailRepository _detailRepo;
  final ShopIdentifier identifier;

//  final FcmTokenRepository _fcmRepo;

//  final OrdersRepository _ordersRepo;
//  final CreateProductRepository _createProductRepo;

//  ManagerUser user;
//  int srvCenterId = -1;

//  final List<Shop> _shops = [];

//  final List<ShopOrder> _orders = [];

  StreamSubscription _streamSubscription;

  ShopManagementBloc(
    this._managementRepo,
    this.identifier,
    this._detailRepo,
//      this._createProductRepo,
    /*this._ordersRepo,*/ /*this._fcmRepo*/
  );

  @override
  void onError(Object error, StackTrace stacktrace) {
    print("Shop Management Bloc Error" + error.toString());
    print(stacktrace);
  }

  @override
  ShopManagerState get initialState => LoadingShopData();

  @override
  Stream<ShopManagerState> mapEventToState(ShopManagerEvent event) async* {
    if (event is GetShopProducts) {
      yield LoadingShopData();

      var products = await _managementRepo.getShopProducts(identifier);

      var details = products.map((product) async {
        var detail = await _detailRepo.load(product.id.toString());
        var seller = detail.getSellerById(product.sellerId);
        if (seller != null) {
          return DetailedShopProduct(
              product, seller.stockQuantity, seller.saleCount);
        } else {
          return DetailedShopProduct(product, product.stockQuantity, 0);
        }
      });

      List<DetailedShopProduct> detailedProducts = await Future.wait(details);

      yield ShopDataLoaded(identifier, detailedProducts);
    }
    /*else if (event is EditShopProduct) {
      var user = _getUserIfLoggedIn();
      if (user != null) {
        yield LoadingSMData();

        var success =
            await _managementRepo.editProductOfSeller(event.shopProducts);

        var mappedList =
            _shops.map((s) => s.identifier).map((shopIdentifier) async {
          return await _managementRepo.getFullShop(shopIdentifier);
        });
        var shops = await Future.wait(mappedList);

        if (success) {
          Helpers.showToast('تغییرات با موفقیت انجام شد');
          yield SMDataLoaded(user, shops: shops);
        } else {
          Helpers.showToast('خطا در ثبت محصولات');
          yield SMDataLoaded(user, shops: shops);
        }
      } else {
        print(
            'MANAGEMENT_BLOC_ERROR: cant edit product when not logged in, this should not happen');
      }
    } else if (event is AddShopProduct) {
      var user = _getUserIfLoggedIn();
      if (user != null) {
        yield LoadingSMData();
        var success = await _managementRepo.submitProduct(
            event.pricingProduct, event.shopIdentifier.id.toString());
        if (success) {
          var mappedList =
              _shops.map((s) => s.identifier).map((shopIdentifier) async {
            return await _managementRepo.getFullShop(shopIdentifier);
          });

          var shops = await Future.wait(mappedList);

          yield SMDataLoaded(user, shops: shops);
        } else {
          yield SMDataFailed('error editing shop products');
        }
      } else {
        print(
            'MANAGEMENT_BLOC_ERROR: cant edit product when not logged in, this should not happen');
      }
    }*/
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
