import 'package:store/store/products/filter/filter.dart';

import '../netclient.dart';

class PreviousOrdersRepository {
  final Net _net;

  PreviousOrdersRepository(this._net);

  Stream<List<PaidOrder>> getPaidOrders(String sellerId) async* {
    PostResponse response = await _net.post(EndPoint.GET_PAID_ORDERS, body: {
      /*'seller_id': sellerId*/
    });
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      yield list.map(parse).toList();
    } else {
      yield [];
    }
  }

  PaidOrder parse(Map<String, dynamic> json) {
    return PaidOrder.fromJson(json);
  }
}

class PaidOrder {
  final int orderId;
  final String orderCode;
  final String orderDate;
  final Price total;
  final bool isCompleted;
  final String centerName;

  final List<OrderProductInfo> products;

  String get city => products[0]._cityName ?? '';

  String get address => products[0]._address ?? '';

  String get shopName => products[0].shopName ?? '';


  PaidOrder(this.orderId, this.orderCode, this.orderDate, this.total,
      this.isCompleted, this.centerName, this.products);

  factory PaidOrder.fromJson(Map<String, dynamic> json) {
    return PaidOrder(
        json['order_id'],
        json['order_code'],
        json['order_date'],
        Price(json['total_amount'].toString()),
        json['is_completed'] == 1,
        json['center_name'],
        List.of(json['items'])
            .map((item) => OrderProductInfo.fromJson(item))
            .toList());
  }
}

class OrderProductInfo {
  final int variantId;
  final String variantCode;
  final String name;
  final String shopName;
  final int sellerId;
  final String _cityName;
  final String _address;

  OrderProductInfo(this.variantId, this.variantCode, this.name, this.shopName,
      this.sellerId, this._cityName, this._address);

  factory OrderProductInfo.fromJson(Map<String, dynamic> json) {
    return OrderProductInfo(
        json['variant_id'],
        json['variant_code'],
        json['product_title_fa'],
        json['seller'],
        json['seller_id'],
        json['seller_city'],
        json['user_address']);
  }
}
