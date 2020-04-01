import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/management/management_login_bloc.dart';

import 'order_bloc_event_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrdersRepository _ordersRepository;
  final LoginStatusBloc _loginStatusBloc;
  final ManagerLoginBloc _managerLoginBloc;
  StreamSubscription _loginSubscription;

  @override
  void onEvent(OrderEvent event) {
    print("ORDER_BLOC: new event: $event");
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('ORDER BLOC ERROR' + error.toString());
    print(stacktrace);
  }

  OrderBloc(
      this._ordersRepository, this._loginStatusBloc, this._managerLoginBloc);

  @override
  OrderState get initialState => LoadingOrder();

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is GetUserOrders) {
      yield LoadingOrder();
      var loginState = _loginStatusBloc.currentState;
      if (loginState is IsLoggedIn) {
        var orders =
            await _ordersRepository.getUserOrders(loginState.user.sessionId);
        yield OrdersLoaded(orders);
      } else {
        print('error: user not logged in to get orders');
      }
    } else if (event is GetShopOrders) {
      var orders = await _ordersRepository.getShopOrders(event.shopId);
      yield OrdersLoaded(orders);
    } else if (event is OrderPacked) {
      var orders = await _ordersRepository.orderPacked(
          event.orderId, event.sellerId, event.comment);
      yield OrdersLoaded(orders);
    }
  }

  @override
  void dispose() {
    _loginSubscription.cancel();
    super.dispose();
  }
}
