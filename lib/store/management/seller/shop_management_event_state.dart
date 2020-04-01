import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/data_layer/management/management_repository.dart';
import 'package:store/store/management/seller/shop_add_product_page.dart';

import '../model.dart';

@immutable
abstract class ShopManagerEvent extends BlocEvent {}

@immutable
abstract class ShopManagerState extends BlocState {}

// STATES *******************************
class ShopDataLoaded extends ShopManagerState {
  final ShopIdentifier identifier;
  final List<DetailedShopProduct> products;

  ShopDataLoaded(this.identifier, this.products);

  @override
  toString() => 'identifier: $identifier  products: $products';
}

class LoadingShopData extends ShopManagerState {
  LoadingShopData();

  @override
  String toString() {
    return " STATE: user isn't logged in";
  }
}

class LoadingShopDataFailed extends ShopManagerState {
  final String error;

  LoadingShopDataFailed(this.error);

  @override
  String toString() {
    return " STATE: error loading shop management data : $error";
  }
}

// EVENTS *******************************
/*
class ShopManagerLogin extends ShopManagerEvent {
  final String email;
  final String password;

  ShopManagerLogin(this.email, this.password);

  @override
  String toString() => "shop manager login event: $email $password";
}
*/

class GetShopProducts extends ShopManagerEvent {
//  final ShopIdentifier identifier;

  GetShopProducts(/*this.identifier*/);

  @override
  toString() => 'get shop event';
}

class AddShopProduct extends ShopManagerEvent {
  final ShopIdentifier shopIdentifier;
  final PricingProduct pricingProduct;

  AddShopProduct(this.pricingProduct, this.shopIdentifier);
}

class EditShopProduct extends ShopManagerEvent {
  final List<ShopProduct> shopProducts;

  EditShopProduct(this.shopProducts);
}

/*
class LogoutManager extends ShopManagerEvent {}

class InitiateManagerLogin extends ShopManagerEvent {}

// login status
@immutable
abstract class ShopManagement extends Equatable {
  bool isLoggedIn();
}
*/
