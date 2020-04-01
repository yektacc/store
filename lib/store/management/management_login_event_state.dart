import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';

import 'model.dart';

@immutable
abstract class ManagerLoginEvent extends BlocEvent {}

@immutable
abstract class ManagerLoginState extends BlocState {}

// STATES *******************************
class SMWaitingForLogin extends ManagerLoginState {
  @override
  String toString() {
    return "STATE: waiting for login";
  }
}

class ManagerLoggedIn extends ManagerLoginState {
/*  final List<ShopIdentifier> shops;
  final List<ServiceIdentifier> services;*/

  final ManagerUser user;

//  final List<ShopOrder> orders;

  ManagerLoggedIn(this.user);

  @override
  String toString() {
    return "STATE: loading login status";
  }
}

class LoadingSMData extends ManagerLoginState {
  LoadingSMData();

  @override
  String toString() {
    return " STATE: user isn't logged in";
  }
}

class SMDataFailed extends ManagerLoginState {
  final String error;

  SMDataFailed(this.error);

  @override
  String toString() {
    return " STATE: error loading shop management data : $error";
  }
}

// EVENTS *******************************
class ShopManagerLogin extends ManagerLoginEvent {
  final String email;
  final String password;

  ShopManagerLogin(this.email, this.password);

  @override
  String toString() => "shop manager login event: $email $password";
}

/*class AddShopProduct extends ManagementEvent {
  final ShopIdentifier shopIdentifier;
  final PricingProduct pricingProduct;

  AddShopProduct(this.pricingProduct, this.shopIdentifier);
}

class EditShopProduct extends ManagementEvent {
  final List<ShopProduct> shopProducts;

  EditShopProduct(this.shopProducts);
}*/

class LogoutManager extends ManagerLoginEvent {}

class InitiateManagerLogin extends ManagerLoginEvent {}

// login status
@immutable
abstract class ShopManagement extends Equatable {
  bool isLoggedIn();
}
