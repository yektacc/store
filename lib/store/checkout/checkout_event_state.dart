import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/data_layer/cart/cart_repository.dart';
import 'package:store/data_layer/order/save_order_repository.dart';
import 'package:store/store/checkout/coupon/coupon_repository.dart';
import 'package:store/store/location/address/model.dart';
import 'package:store/store/products/cart/model.dart';

@immutable
abstract class CheckoutEvent extends BlocEvent {}

@immutable
abstract class CheckoutState extends BlocState {}

// STATES *******************************

// order states
class SimpleOrder extends CheckoutState {
  final OrderInfo orderInfo;
  final Cart cart;

  SimpleOrder(
    this.orderInfo,
    this.cart,
  );
}

class OrderWithDeliveryInf extends SimpleOrder {
  final Address address;
  final DeliveryInfo deliveryInfo;

  OrderWithDeliveryInf(orderInfo, cart, this.address, this.deliveryInfo)
      : super(orderInfo, cart);
}

class OrderPayment extends OrderWithDeliveryInf {
  final List<ValidCoupon> validCoupons = [];

  int get productsTotal => cart.total;

  int get deliveryPrice => deliveryInfo.totalPrice.amount;

  int get tax => (productsTotal * (9 / 100)).toInt();

  int get taxedTotalWithoutDiscount => tax + productsTotal;

  int get couponSum =>
      validCoupons.fold(0, (prev, coupon) => prev + coupon.discount.amount);

  int get toPayAmount => taxedTotalWithoutDiscount - couponSum + deliveryPrice;

  OrderPayment(orderInfo, cart, address, deliveryInfo)
      : super(orderInfo, cart, address, deliveryInfo);

  addCoupon(ValidCoupon coupon) {
    validCoupons.add(coupon);
  }
}

class LaunchGateway extends OrderPayment {
  final String url;
  final int amount;
  final String authority;

  LaunchGateway(this.url, this.amount, this.authority, OrderPayment prevState)
      : super(prevState.orderInfo, prevState.cart, prevState.address,
            prevState.deliveryInfo);
}

class VerifyingPayment extends OrderPayment {
  VerifyingPayment(orderInfo, cart, address, deliveryInfo)
      : super(orderInfo, cart, address, deliveryInfo);
}

class PaymentSuccessful extends OrderPayment {
  PaymentSuccessful(orderInfo, cart, address, deliveryInfo)
      : super(orderInfo, cart, address, deliveryInfo);
}

// other states
class CheckoutCart extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutNotLoggedIn extends CheckoutState {}

class InitialState extends CheckoutState {
  InitialState();

  @override
  String toString() {
    return "STATE: loading";
  }
}

// EVENTS

class SubmitCart extends CheckoutEvent {
  final Cart cart;

  SubmitCart(this.cart);
}

class SubmitAddress extends CheckoutEvent {
  final Address address;

//  final CheckoutAddress prevState;

  SubmitAddress(this.address /*, this.prevState*/);
}

class SubmitDelivery extends CheckoutEvent {
  final DeliveryTime deliveryTime;

//  final OrderWithDeliveryInf prevState;

  SubmitDelivery(
    this.deliveryTime,
    /* this.prevState*/
  );
}

class AddCoupon extends CheckoutEvent {
  final String code;

  AddCoupon(this.code);
}

class ReadyForGateway extends CheckoutEvent {}

class CheckoutClear extends CheckoutEvent {}

class VerifyPayment extends CheckoutEvent {}

class HandlePaymentError extends CheckoutEvent {}
