import 'dart:core';

import '../netclient.dart';

class ShippingCostRepo {
  final Net _client;

  ShippingCostRepo(this._client);

  Future<List<ShippingCost>> fetch() async {
    PostResponse response = await _client.post(EndPoint.GET_SHIPPING_COST);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list.map((json) => ShippingCost.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}

class ShippingCost {
  final String cost;

  ShippingCost(this.cost);

  factory ShippingCost.fromJson(Map<String, dynamic> json) =>
      ShippingCost(json['cost']);
}
