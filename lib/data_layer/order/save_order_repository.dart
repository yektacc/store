import 'dart:convert';
import 'dart:core';

import 'package:store/data_layer/payment/delivery/delivery_time.dart';

import '../netclient.dart';

class SaveOrderRepository {
  final Net _net;

  SaveOrderRepository(this._net);

  Future<int> saveFinal(String sessionId, String orderCode,
      int addressId) async {
    PostResponse response = await _net.post(EndPoint.SAVE_FINAL_ORDER, body: {
      'session_id': sessionId,
      'order_code': orderCode,
      'transferee_address_id': addressId.toString(),
      'payment_method': 1
    });
    if (response is SuccessResponse) {
      return Map<String, dynamic>.from(response.data)['payment_id'];
    } else {
      return -1;
    }
  }

  Future<bool> save(String sessionId, String orderCode, String addressId,
      int totalAmount, int shippingCost, DeliveryTime deliveryTime) async {
    PostResponse response = await _net.post(EndPoint.SAVE_ORDER, body: {
      'session_id': sessionId,
      'order_code': orderCode,
      'transferee_address_id': addressId,
      'total_amount': totalAmount.toString(),
      'delivery_date': jsonEncode(deliveryTime.toJson()),
      'shipment_cost': shippingCost.toString(),
    });
    return response is SuccessResponse;
  }

  Future<bool> saveTransaction(String orderId, String sellerId,
      String deliveryCost) async {
    var res = await _net.post(EndPoint.SAVE_TRANSACTION, body: {
      'order_id': orderId,
      'seller_id': sellerId,
      'tariff_amount': deliveryCost,
    });

    return res is SuccessResponse;
  }

  Future<bool> saveFinalTransaction(int paymentId) async {
    var res = await _net.post(EndPoint.PAYMENT_FINAL_TRANSACTION,
        body: {'payment_id': paymentId.toString()});
    return res is SuccessResponse;
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
