import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import '../netclient.dart';

part 'payment_repository.g.dart';

class PaymentRepo {
  final Net _client;

  PaymentRepo(this._client);

  Future<List<PaymentType>> getTypes() async {
    PostResponse response = await _client.post(EndPoint.GET_PAYMENT_TYPES);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list.map((json) => PaymentType.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<bool> savePayment(int refId, int amount, String status,
      String sessionId) async {
    PostResponse response = await _client.post(EndPoint.SAVE_PAYMENT_INFO,
        body: {
          'ref_id': refId.toString(),
          'status': status,
          'amount': amount.toString(),
          'session_id': sessionId
        });
    if (response is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }
}

@JsonSerializable()
class PaymentType {
  final String id;
  final String title;

  PaymentType(this.id, this.title);

  factory PaymentType.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentTypeToJson(this);
}
