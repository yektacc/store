import 'package:bloc/bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/cart/cart_repository.dart';
import 'package:store/data_layer/centers/centers_repository.dart';
import 'package:store/data_layer/order/save_order_repository.dart';
import 'package:store/data_layer/payment/delivery/delivery_price_repository.dart';
import 'package:store/services/centers/model.dart';
import 'package:store/store/checkout/coupon/coupon_repository.dart';
import 'package:store/store/checkout/zarin_pal/client.dart';
import 'package:store/store/location/provinces/model.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/products/cart/model.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';
import 'package:store/store/products/filter/filter.dart';

import 'checkout_event_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final DeliveryPriceRepository _deliveryPriceRepo;
  final CartRepository _cartRep;
  final LoginStatusBloc _loginStatusBloc;
  final CentersRepository _centersRepo;
  final ProductDetailRepository _detailRepo;
  final SaveOrderRepository _orderRepo;
  final CouponRepository _couponRepository;

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
    print(stacktrace);
  }

  CheckoutBloc(
      this._deliveryPriceRepo,
      this._cartRep,
      this._loginStatusBloc,
      this._centersRepo,
      this._detailRepo,
      this._orderRepo,
      this._couponRepository);

  @override
  CheckoutState get initialState {
    return InitialState();
  }

  @override
  void onEvent(CheckoutEvent event) {
    print('NEW CHECKOUT EVENT:' + event.toString());
  }

  @override
  Stream<CheckoutState> mapEventToState(CheckoutEvent event) async* {
    if (event is SubmitCart) {
      var loginState = _loginStatusBloc.currentState;

      if (loginState is IsLoggedIn) {
        if (loginState is IsLoggedIn) {
          var orderInfo = await _cartRep.sendCart(loginState.user.sessionId,
              event.cart.products, event.cart.total.toString());
          if (orderInfo != null) {
            yield SimpleOrder(orderInfo, event.cart);
          } else {
            Helpers.showToast(('خطا! مجددا تلاش کنید'));
          }
        }
      } else {
        yield CheckoutNotLoggedIn();
      }
    } else if (event is SubmitAddress) {
      var loginState = _loginStatusBloc.currentState;

      if (loginState is IsLoggedIn && currentState is SimpleOrder) {
        var state = currentState as SimpleOrder;

        var deliveryInfo = await getDeliveryInfo(state.cart.products);

        if (deliveryInfo != null) {
          yield OrderWithDeliveryInf(
              state.orderInfo, state.cart, event.address, deliveryInfo);
        } else {
          Helpers.errorToast();
        }
      } else {
        yield CheckoutNotLoggedIn();
      }
    } else if (event is SubmitDelivery) {
      var loginState = _loginStatusBloc.currentState;

      if (loginState is IsLoggedIn && currentState is OrderWithDeliveryInf) {
        var state = currentState as OrderWithDeliveryInf;
        var success = await _orderRepo.save(
            loginState.user.sessionId,
            state.orderInfo.orderCode,
            state.address.id.toString(),
            state.cart.total,
            state.deliveryInfo.totalPrice.amount,
            event.deliveryTime);
        if (success) {
          yield OrderPayment(
              state.orderInfo, state.cart, state.address, state.deliveryInfo);
        }
      } else {
        yield CheckoutNotLoggedIn();
      }
    } else if (event is AddCoupon) {
      var loginState = _loginStatusBloc.currentState;

      if (loginState is IsLoggedIn) {
        if (currentState is OrderPayment) {
          var paymentState = (currentState as OrderPayment);
          yield CheckoutLoading();
          var validCoupon = await _couponRepository.validateCoupon(
              event.code,
              paymentState.deliveryInfo.items
                  .map((di) => di.sellerId)
                  .toList());

          if (validCoupon != null) {
            paymentState.addCoupon(validCoupon);
          }

          yield (paymentState);
        }
      } else {
        yield CheckoutNotLoggedIn();
      }
    } else if (event is ReadyForGateway) {
      var loginState = _loginStatusBloc.currentState;

      if (loginState is IsLoggedIn) {
        if (currentState is OrderPayment) {
          var paymentState = (currentState as OrderPayment);
          yield CheckoutLoading();

          var mappedList = paymentState.deliveryInfo.items.map((di) async {
            return await _orderRepo.saveTransaction(
                paymentState.orderInfo.orderId.toString(),
                di.sellerId.toString(),
                di.price.amount.toString());
          }).toList();

          List<bool> successList = await Future.wait(mappedList);

          bool allSuccess =
              successList.fold(true, (prev, success) => prev && success);

          if (allSuccess) {
            var res = await ZarinPalClient().getPaymentURL(
                ZPPaymentRequest((paymentState.toPayAmount).toString()));
            if (res is ZPPaymentSuccessResponse) {
              yield LaunchGateway(res.getURL(), paymentState.toPayAmount,
                  res.authority, paymentState);
            } else {
              Helpers.showToast('خطا در اتصال به درگاه پرداخت');
            }
          }
        }
      } else {
        yield CheckoutNotLoggedIn();
      }
    } else if (event is VerifyPayment) {
      var loginState = _loginStatusBloc.currentState;

      if (loginState is IsLoggedIn) {
        if (currentState is LaunchGateway) {
          var gatewayState = (currentState as LaunchGateway);
          yield VerifyingPayment(gatewayState.orderInfo, gatewayState.cart,
              gatewayState.address, gatewayState.deliveryInfo);

          var res = await ZarinPalClient().verifyPayment(ZPVerifyRequest(
              gatewayState.authority, gatewayState.amount.toString()));

          if (res is ZPVerifySuccessResponse) {
//            var res = _orderRepo.saveFinal(loginState.user.sessionId, orderCode)
            var saveFinal = await _orderRepo.saveFinal(
                loginState.user.sessionId,
                gatewayState.orderInfo.orderCode,
                gatewayState.address.id);

            if (saveFinal != -1) {
              var saveFinalTransaction =
                  await _orderRepo.saveFinalTransaction(saveFinal);
              if (saveFinalTransaction) {
                yield PaymentSuccessful(
                    gatewayState.deliveryInfo,
                    gatewayState.cart,
                    gatewayState.address,
                    gatewayState.deliveryInfo);
              } else {
                Helpers.showToast(
                    'خطا در پردازش نهایی سفارش: ' + gatewayState.authority);
              }
            }
          } else {
            Helpers.errorToast();
          }

          /*if (res is ZPPaymentSuccessResponse) {
            yield LaunchGateway(res.getURL());
          } else {
            Helpers.showToast('خطا در اتصال به درگاه پرداخت');
          }*/
        }
      } else {
        yield CheckoutNotLoggedIn();
      }
    }
  }

// handler methods

  Future<DeliveryInfo> getDeliveryInfo(List<CartProduct> products) async {
    List<DeliveryItem> deliveryItems = [];

    List<WeightProduct> weightedProducts = await getWeightedProducts(products);

    print('weighted products: ' + weightedProducts.toString());

    var stores =
        await _centersRepo.getCenters(CenterFilter(CenterFetchType.STORE));

    if (stores != null) {
      if (stores.isNotEmpty && stores[0].typeId == 4) {
        List<CenterItem> shops = stores;

        City tmpCity;

        weightedProducts.forEach((product) {
          tmpCity = getCityProvinceByShopId(
              int.parse(product.product.storeThumbnail.id), shops)[0];

          Province province = getCityProvinceByShopId(
              int.parse(product.product.storeThumbnail.id), shops)[1];

          if (deliveryItems
              .map((di) => di.sellerId)
              .contains(int.parse(product.product.storeThumbnail.id))) {
            var availableDi = deliveryItems
                .firstWhere((DeliveryItem di) =>
                    di.sellerId == int.parse(product.product.storeThumbnail.id))
                .products
                .add(product);
          } else {
            deliveryItems.add(DeliveryItem(tmpCity, province, [product],
                int.parse(product.product.storeThumbnail.id)));
          }
        });

        var mappedList = deliveryItems.map((di) async {
          var price = await getDeliveryPrice(di);
          return PricedDeliveryItem(di, price);
        }).toList();

        List<PricedDeliveryItem> pricedDeliveryItems =
            await Future.wait(mappedList);

        return DeliveryInfo(pricedDeliveryItems);
      }
    } else {
      return null;
    }

    /* await for (final state in _centersBloc.state) {

    }*/
  }

  List getCityProvinceByShopId(int shopId, List<CenterItem> shops) {
    print('shops: ${shops.map((s) => s.id).toList().toString()}');
    print('shopId: $shopId');

    if (shops.map((s) => s.id).contains(shopId)) {
      return [
        shops.firstWhere((shop) => shop.id == shopId).city,
        shops.firstWhere((shop) => shop.id == shopId).province
      ];
    } else {
      Helpers.showToast(
          '${shops.map((s) => s.id.toString() + ' ')}خطا در اتصال!');
    }
  }

  Future<List<WeightProduct>> getWeightedProducts(
      List<CartProduct> allCartProducts) async {
    print("all cart products in weightproducts function: " +
        allCartProducts.toString());

    var mappedList = allCartProducts.map((cartProduct) async {
      return await weightProduct(cartProduct);
    }).toList();

    List<WeightProduct> list = await Future.wait(mappedList);

    return list;
  }

  Future<Price> getDeliveryPrice(DeliveryItem item) async {
    var price = await _deliveryPriceRepo.getPrice(
        item.city, item.province, item.getTotalWeight());

    return Price(price.toString());
  }

  Future<WeightProduct> weightProduct(CartProduct cartProduct) async {
    print("weight function called: $cartProduct");
    var detail = await _detailRepo.load(cartProduct.product.id);
    return WeightProduct(cartProduct, double.parse(detail.weight),
        detail.unit == 'کیلوگرم' ? 1 : 0);
  }
}
