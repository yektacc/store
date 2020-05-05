import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';

@immutable
abstract class OrderEvent extends BlocEvent {}

@immutable
abstract class OrderState extends BlocState {
  OrderState([List props = const []]) : super(props);
}

// STATES *******************************

class LoadingOrder extends OrderState {
  LoadingOrder();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class OrdersLoaded extends OrderState {
  final List<PaidOrder> orders;

  OrdersLoaded(this.orders);

  @override
  String toString() {
    return "STATE: loaded: $orders";
  }
}

// EVENTS *******************************

class GetShopOrders extends OrderEvent {
  final int shopId;

  GetShopOrders(this.shopId);

  @override
  String toString() {
    return "get order";
  }
}

class GetUserOrders extends OrderEvent {
  GetUserOrders();

  @override
  String toString() {
    return "get order";
  }
}

class OrderPacked extends OrderEvent {
  final int orderId;
  final int sellerId;
  final String comment;

  OrderPacked(this.comment, this.orderId, this.sellerId);
}

class SubmitProductReturn extends OrderEvent {
  final OrderProductInfo product;
  final String comment;

  SubmitProductReturn(this.product, this.comment);

  @override
  String toString() {
    return 'submit product return event : $product';
  }
}
