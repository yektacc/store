import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';

import 'order_product_bloc_event_state.dart';

class PackingBloc extends Bloc<OrderProductEvent, OrderProductState> {
  final OrdersRepository _ordersRepository;

//  final LoginStatusBloc _loginStatusBloc;

//  final ManagerLoginBloc _managerLoginBloc;
  StreamSubscription _loginSubscription;

  final OrderProductInfo _product;

  @override
  void onEvent(OrderProductEvent event) {
    print("ORDER_BLOC: new event: $event");
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('ORDER BLOC ERROR' + error.toString());
    print(stacktrace);
  }

  PackingBloc(this._ordersRepository, this._product);

  @override
  OrderProductState get initialState {
    return OrderProductLoading();
  }

  @override
  Stream<OrderProductState> mapEventToState(OrderProductEvent event) async* {
    if (event is GetPackingInfo) {
      yield OrderProductLoading();
      var orderDelivery =
      await _ordersRepository.checkOrderProductDelivery(_product);
      if (orderDelivery) {
        yield IsPacked(_product);
      } else {
        yield NotPacked(_product);
      }
    } else if (event is ProductPacked) {
      yield OrderProductLoading();
      var orderDelivery = await _ordersRepository.productPacked(
          _product.orderId, _product.itemId);
      if (orderDelivery) {
        yield IsPacked(_product);
      } else {
        yield NotPacked(_product);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _loginSubscription.cancel();
  }
}
