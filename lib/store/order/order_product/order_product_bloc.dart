import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/management/management_login_bloc.dart';

import 'order_product_bloc_event_state.dart';

class OrderProductBloc extends Bloc<OrderProductEvent, OrderProductState> {
  final OrdersRepository _ordersRepository;
  final LoginStatusBloc _loginStatusBloc;
  final ManagerLoginBloc _managerLoginBloc;
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

  OrderProductBloc(this._ordersRepository, this._loginStatusBloc,
      this._managerLoginBloc, this._product);

  @override
  OrderProductState get initialState {
    if (_product.packed) {
      return ProductIsPacked(_product);
    } else {
      return ProductNotPacked(_product);
    }
  }

  @override
  Stream<OrderProductState> mapEventToState(OrderProductEvent event) async* {
    if (event is CheckProductPacking) {
      yield ProductPackingLoading(_product);
      var loginState = _loginStatusBloc.currentState;
      if (loginState is IsLoggedIn) {
        var orderDelivery =
            await _ordersRepository.checkOrderProductDelivery(_product);
        if (orderDelivery) {
          yield ProductIsPacked(_product);
        } else {
          yield ProductNotPacked(_product);
        }
      } else {
        print('error: user not logged in to get orders');
      }
    } else if (event is ProductPacked) {
      yield ProductPackingLoading(_product);
      var loginState = _loginStatusBloc.currentState;
      if (loginState is IsLoggedIn) {
        var orderDelivery = await _ordersRepository.productPacked(
            _product.orderId, _product.itemId);
        if (orderDelivery) {
          yield ProductIsPacked(_product);
        } else {
          yield ProductNotPacked(_product);
        }
      } else {
        print('error: user not logged in to get orders');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _loginSubscription.cancel();
  }
}
