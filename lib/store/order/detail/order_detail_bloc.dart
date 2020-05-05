//import 'dart:async';
//
//import 'package:bloc/bloc.dart';
//import 'package:store/data_layer/order/paid_orders_repository.dart';
//import 'package:store/store/login_register/login_status/login_status_bloc.dart';
//import 'package:store/store/login_register/login_status/login_status_event_state.dart';
//import 'package:store/store/management/manager_login_bloc.dart';
//
//import 'order_detail_bloc_event_state.dart';
//
//class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
//  final OrdersRepository _ordersRepository;
//  final LoginStatusBloc _loginStatusBloc;
//  final ManagerLoginBloc _managerLoginBloc;
//  StreamSubscription _loginSubscription;
//
//  @override
//  void onEvent(OrderDetailEvent event) {
//    print("ORDER_BLOC: new event: $event");
//  }
//
//  @override
//  void onError(Object error, StackTrace stacktrace) {
//    print('ORDER BLOC ERROR' + error.toString());
//    print(stacktrace);
//  }
//
//  OrderDetailBloc(this._ordersRepository, this._loginStatusBloc,
//      this._managerLoginBloc);
//
//  @override
//  OrderDetailState get initialState => LoadingOrderDetail();
//
//  @override
//  Stream<OrderDetailState> mapEventToState(OrderDetailEvent event) async* {
//    if (event is GetUserOrders) {
//      yield LoadingOrderDetail();
//      var loginState = _loginStatusBloc.currentState;
//      if (loginState is IsLoggedIn) {
//        var orders = await _ordersRepository.getUserOrders(
//            loginState.user.sessionId);
//        yield OrderDetailLoaded(orders);
//      } else {
//        print('error: user not logged in to get orders');
//      }
//    } else if (event is GetOrderDetail) {
//      var orders = await _ordersRepository.getShopOrders(
//          event.shopId);
//      yield OrderDetailLoaded(orders);
//    }
//  }
//
//  @override
//  void dispose() {
//    _loginSubscription.cancel();
//  }
//}
