import 'dart:convert';
import 'dart:core';

import 'package:store/data_layer/payment/delivery/delivery_time.dart';

import '../netclient.dart';

class OrderRepository {
  final Net _client;

  OrderRepository(this._client);

  Future<bool> saveFinal(String sessionId, String orderCode) async {
    PostResponse response = await _client.post(EndPoint.SAVE_FINAL_ORDER,
        body: {'session_id': sessionId, 'order_code': orderCode});
    if (response is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> save(String sessionId, String orderCode, String addressId,
      int totalAmount, int shippingCost, DeliveryTime deliveryTime) async {
    PostResponse response = await _client.post(EndPoint.SAVE_ORDER, body: {
      'session_id': sessionId,
      'order_code': orderCode,
      'transferee_address_id': addressId,
      'total_amount': totalAmount.toString(),
      'delivery_date': jsonEncode(deliveryTime.toJson()),
      'shipment_cost': shippingCost.toString(),
    });
    if (response is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }
}

class DeliveryTime {
  final List<DayOfMonth> dayOfMonth;
  final int hourTo;
  final int hourFrom;

  DeliveryTime(this.dayOfMonth, this.hourTo, this.hourFrom);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'days': jsonEncode(dayOfMonth.map((dom) => dom.toJson()).toList()),
      'hour_from': hourFrom,
      'hour_to': hourTo,
    };
  }
}

/*Future<bool> setCart(
      String sessionId, List<String> productIds, String total) async {
    PostResponse response = await _client.post(EndPoint.SEND_SHOPPING_CART,
        body: {
          'session_id': sessionId,
          "cart_items": productIds,
          "total_amount": total
        });
    if (response is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }*/
/*  Future<bool> emptyCart(String sessionId, String orderCode) async {
    PostResponse response =
        await _client.post(EndPoint.EMPTY_SHOPPING_CART, body: {
      'session_id': sessionId,
      "order_code": orderCode,
    });
    if (response is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }*/

/*@JsonSerializable()
class CartItem {
  @JsonKey(name: 'id')
  final int id;

  CartItem(this.id);

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}*/
