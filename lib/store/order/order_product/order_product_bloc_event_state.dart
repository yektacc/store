import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';

@immutable
abstract class OrderProductEvent extends BlocEvent {}

@immutable
abstract class OrderProductState extends BlocState {
  OrderProductState([List props = const []]) : super(props);
}

// STATES *******************************

class ProductPackingLoading extends OrderProductState {
  final OrderProductInfo orderProduct;

  ProductPackingLoading(this.orderProduct);

  @override
  String toString() {
    return "STATE: product packing loading: $orderProduct";
  }
}

class ProductIsPacked extends OrderProductState {
  final OrderProductInfo orderProduct;

  ProductIsPacked(this.orderProduct);

  @override
  String toString() {
    return "STATE: product is packed: $orderProduct";
  }
}

class ProductNotPacked extends OrderProductState {
  final OrderProductInfo orderProduct;

  ProductNotPacked(this.orderProduct);

  @override
  String toString() {
    return "STATE: product not packed: $orderProduct";
  }
}

// EVENTS *******************************

class CheckProductPacking extends OrderProductEvent {
  final OrderProductInfo orderProduct;

  CheckProductPacking(this.orderProduct);

  @override
  String toString() {
    return "check product packing status: $orderProduct";
  }
}

class ProductPacked extends OrderProductEvent {
  final OrderProductInfo orderProduct;

  ProductPacked(this.orderProduct);

  @override
  String toString() {
    return "packing product: $orderProduct";
  }
}
