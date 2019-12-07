import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/payment/delivery/delivery_page.dart';
import 'package:store/store/products/product/product.dart';

import 'cart_product.dart';

@immutable
abstract class CartEvent extends BlocEvent {}

@immutable
abstract class CartState extends BlocState {}

// STATES *******************************

class CartLoading extends CartState {
  CartLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class CartLoadedWithDeliveryItems extends CartLoaded {
  final List<DeliveryItem> deliveryItems;

  CartLoadedWithDeliveryItems(
      List<CartProduct> products, int count, int total, this.deliveryItems)
      : super(products, count, total);
}


/*class CartLoadedWithDeliveryItems extends CartLoaded {
  final List<DeliveryItem> deliveryItems;

  CartLoadedWithDeliveryItems(
      List<CartProduct> products, int count, int total, this.deliveryItems)
      : super(products, count, total);
}*/

class CartLoaded extends CartState {
  final List<CartProduct> products;
  final int total;
  final int count;

  CartLoaded(this.products, this.count, this.total);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class CartFailure extends CartState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

class CartEmpty extends CartState {
  @override
  String toString() {
    return 'STATE: cart is empty';
  }
}

// EVENTS *******************************

class FetchCart extends CartEvent {
  FetchCart();

  @override
  String toString() {
    return "fetch";
  }
}

class Add extends CartEvent {
/*
  final DetailedProduct detailedProduct;
*/
  final Product product;

  Add(/*this.detailedProduct,*/ this.product);
}

class Remove extends CartEvent {
  final Product product;

  Remove(this.product);
}

class Clear extends CartEvent {
  Clear();
}
