import 'package:quiver/core.dart';
import 'package:store/store/products/filter/filter.dart';

import '../netclient.dart';

class OrdersRepository {
  final Net _net;

  OrdersRepository(this._net);

  Future<List<PaidOrder>> getUserOrders(String sessionId) {
    return _getPaidOrders(null, sessionId);
  }

  Future<List<PaidOrder>> getShopOrders(int shopId) {
    return _getPaidOrders(shopId.toString(), null);
  }

  Future<bool> orderPacked(int orderId, int sellerId, String comment) async {
    var res = await _net.post(EndPoint.ORDER_SENT, body: {
      'order_id': orderId.toString(),
      'seller_id': sellerId.toString(),
      'transfer_comment': comment
    });

    return res is SuccessResponse;
  }

  Future<bool> checkOrderProductDelivery(OrderProductInfo product) async {
    var orders = await getShopOrders(product.sellerId);
    try {
      return orders
          .firstWhere((ord) => ord.orderId == product.orderId)
          .products
          .contains(product);
    } catch (e, st) {
      print(e);
      print(st);
      return false;
    }
  }

  Future<bool> productPacked(int orderId, int itemId) async {
    var res = await _net.post(EndPoint.ORDER_PRODUCT_PACKED, body: {
      'order_id': orderId.toString(),
      'item_id': itemId.toString(),
    });

    return res is SuccessResponse;
  }

  Future<List<PaidOrder>> _getPaidOrders(String sellerId,
      String sessionId) async {
    var body;
    bool isShopOrder;
    if (sellerId != null) {
      isShopOrder = true;
      body = {'seller_id': sellerId};
    } else {
      isShopOrder = false;
      body = {'session_id': sessionId};
    }
    PostResponse response =
    await _net.post(EndPoint.GET_PAID_ORDERS, body: body);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list
          .map(
            (json) => parse(json, isShopOrder),
      )
          .toList();
    } else {
      return [];
    }
  }

  PaidOrder parse(Map<String, dynamic> json, bool shopOrder) {
    var paidOrder = PaidOrder.fromJson(json);
    if (shopOrder) {
      return ShopPaidOrder.fromPaidOrder(paidOrder);
    } else {
      return UserPaidOrder.fromPaidOrder(paidOrder);
    }
  }
}

class PaidOrder {
  final int orderId;
  final String orderCode;
  final String orderDate;
  final Price total;
  final Price shippingCost;
  final bool packed;

//  final bool isCompleted;
//  final String centerName;
  final String address;

  final List<OrderProductInfo> products;

  String get city => address.split('-')[0] + " " + address.split('-')[1];

//  String get address => products[0]._address ?? '';

  String get shopName => products[0].shopName ?? '';

  PaidOrder(this.orderId,
      this.orderCode,
      this.orderDate,
      this.total,
      this.shippingCost,
      this.address,
      this.packed,
      this.products,);

  factory PaidOrder.fromJson(Map<String, dynamic> json) {
    return PaidOrder(
        json['order_id'],
        json['order_code'],
        json['order_date'],
        Price(json['total_amount'].toString()),
        Price(json['shipment_cost'].toString()),
        json['user_address'],
/*        json['is_completed'] == 1,
        json['center_name'],*/
        false,
        List.of(json['items'])
            .map((item) => OrderProductInfo.fromJson(item, json['order_id']))
            .toList());
  }
}

class UserPaidOrder extends PaidOrder {
  UserPaidOrder(int orderId, String orderCode, String orderDate, Price total,
      Price shippingCost, String address, List<OrderProductInfo> products)
      : super(
      orderId,
      orderCode,
      orderDate,
      total,
      shippingCost,
      address,
      products);

  factory UserPaidOrder.fromPaidOrder(PaidOrder paidOrder) {
    return UserPaidOrder(
        paidOrder.orderId,
        paidOrder.orderCode,
        paidOrder.orderDate,
        paidOrder.total,
        paidOrder.shippingCost,
        paidOrder.address,
        paidOrder.products);
  }
}

class ShopPaidOrder extends PaidOrder {
  ShopPaidOrder(int orderId, String orderCode, String orderDate, Price total,
      Price shippingCost, String address, List<OrderProductInfo> products)
      : super(
      orderId,
      orderCode,
      orderDate,
      total,
      shippingCost,
      address,
      products);

  factory ShopPaidOrder.fromPaidOrder(PaidOrder paidOrder) {
    return ShopPaidOrder(
        paidOrder.orderId,
        paidOrder.orderCode,
        paidOrder.orderDate,
        paidOrder.total,
        paidOrder.shippingCost,
        paidOrder.address,
        paidOrder.products);
  }
}

class OrderProductInfo {
  final int variantId;
  final String variantCode;
  final String name;
  final int quantity;
  final int unitPrice;
  final String shopName;
  final int sellerId;
  final int itemId;
  final int orderId;
  final bool packed;
  final String _cityName;

  OrderProductInfo(this.variantId,
      this.variantCode,
      this.name,
      this.quantity,
      this.unitPrice,
      this.shopName,
      this.sellerId,
      this._cityName,
      this.itemId,
      this.packed,
      this.orderId);

  factory OrderProductInfo.fromJson(Map<String, dynamic> json, int orderId) {
    return OrderProductInfo(
        json['variant_id'],
        json['variant_code'],
        json['product_title_fa'],
        json['quantity'],
        json['unit_price'],
        json['seller'],
        json['seller_id'],
        json['seller_city'],
        json['item_id'],
        false,
        orderId);
  }

  @override
  bool operator ==(other) {
    return other is OrderProductInfo &&
        other.orderId == this.orderId &&
        other.itemId == this.itemId;
  }

  @override
  int get hashCode {
    return hash2(orderId, itemId);
  }
}
