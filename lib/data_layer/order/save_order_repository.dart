import 'dart:convert';
import 'dart:core';

import 'package:store/data_layer/payment/delivery/delivery_time.dart';

import '../netclient.dart';

class SaveOrderRepository {
  final Net _net;

  SaveOrderRepository(this._net);

  Future<bool> saveFinal(String sessionId, String orderCode,
      int addressId) async {
    PostResponse response =
    await _net.post(EndPoint.SAVE_FINAL_ORDER, cacheEnabled: false, body: {
      'session_id': sessionId,
      'order_code': orderCode,
      'transferee_address_id': addressId.toString(),
      'payment_method': "1"
    });
    if (response is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> save(String sessionId, String orderCode, String addressId,
      int totalAmount, int shippingCost, DeliveryTime deliveryTime) async {
    PostResponse response =
    await _net.post(EndPoint.SAVE_ORDER, cacheEnabled: false, body: {
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
    var res =
    await _net.post(EndPoint.SAVE_TRANSACTION, cacheEnabled: false, body: {
      'order_id': orderId,
      'seller_id': sellerId,
      'tariff_amount': deliveryCost,
    });

    return res is SuccessResponse;
  }

  Future<bool> saveFinalTransaction(int paymentId) async {
    var res = await _net.post(EndPoint.PAYMENT_FINAL_TRANSACTION,
        cacheEnabled: false, body: {'payment_id': paymentId.toString()});
    return res is SuccessResponse;
  }

  Future<int> savePaymentInfo(String refId, int amount, String status,
      String sessionId, String orderCode) async {
    PostResponse response = await _net.post(EndPoint.SAVE_PAYMENT_INFO, body: {
      'ref_id': refId.toString(),
      'status': status,
      'amount': amount.toString(),
      'order_code': orderCode,
      'session_id': sessionId
    });
    if (response is SuccessResponse) {
      return Map<String, dynamic>.from(response.data)['payment_id'];
    } else {
      return -1;
    }
  }
}

class DeliveryTime {
  final List<PersianDayOfMonth> dayOfMonth;
  final int hourTo;
  final int hourFrom;

  DeliveryTime(this.dayOfMonth, this.hourTo, this.hourFrom);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'days': jsonEncode(dayOfMonth
          .map((dom) => GregorianDayOfMonth.fromPersian(dom).toJson())
          .toList()),
      'time': jsonEncode([
        {
          'hour_from': hourFrom,
          'hour_to': hourTo,
        }
      ])
    };
  }
}
