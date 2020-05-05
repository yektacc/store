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

class OrderProductLoading extends OrderProductState {
  OrderProductLoading();

  @override
  String toString() {
    return "STATE: product packing loading";
  }
}

class IsPacked extends OrderProductState {
  final OrderProductInfo orderProduct;

  IsPacked(this.orderProduct);

  @override
  String toString() {
    return "STATE: product is packed: $orderProduct";
  }
}

class NotPacked extends OrderProductState {
  final OrderProductInfo orderProduct;

  NotPacked(this.orderProduct);

  @override
  String toString() {
    return "STATE: product not packed: $orderProduct";
  }
}

// EVENTS *******************************

class GetPackingInfo extends OrderProductEvent {
//  final OrderProductInfo orderProduct;

  GetPackingInfo(/*this.orderProduct*/);

  @override
  String toString() {
    return "check product packing status";
  }
}

class ProductPacked extends OrderProductEvent {
  ProductPacked();

  @override
  String toString() {
    return "packing product";
  }
}


