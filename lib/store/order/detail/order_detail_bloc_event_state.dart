import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';

@immutable
abstract class OrderDetailEvent extends BlocEvent {}

@immutable
abstract class OrderDetailState extends BlocState {
  OrderDetailState([List props = const []]) : super(props);
}

// STATES *******************************

class LoadingOrderDetail extends OrderDetailState {
  LoadingOrderDetail();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class OrderDetailLoaded extends OrderDetailState {
  final List<PaidOrder> orders;

  OrderDetailLoaded(this.orders);

  @override
  String toString() {
    return "STATE: loaded: $orders";
  }
}

// EVENTS *******************************

class GetOrderDetail extends OrderDetailEvent {
  final int shopId;
  final int orderId;

  GetOrderDetail(this.shopId, this.orderId);

  @override
  String toString() {
    return "get order";
  }
}
