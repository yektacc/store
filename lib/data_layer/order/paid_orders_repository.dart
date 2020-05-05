import 'package:quiver/core.dart';
import 'package:store/store/products/filter/filter.dart';

import '../netclient.dart';

class OrdersRepository {
  final Net _net;

  OrdersRepository(this._net);

  Future<List<UserPaidOrder>> getUserOrders(String sessionId) async {
    PostResponse response =
    await _net.post(EndPoint.GET_PAID_ORDERS, body: {'seller_id': '6'},
        cacheEnabled: false);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list
          .map(
            (json) => (parse(json, false) as UserPaidOrder),
      )
          .toList();
    } else {
      return [];
    }
  }

  Future<List<ShopPaidOrder>> getShopOrders(int shopId) async {
    var body = {'seller_id': shopId};

    PostResponse response =
    await _net.post(EndPoint.GET_PAID_ORDERS, body: body, cacheEnabled: false);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list
          .map(
            (json) => (parse(json, true) as ShopPaidOrder),
      )
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> orderPackedCompletely(int orderId, int sellerId,
      String comment) async {
    var res = await _net.post(EndPoint.ORDER_SENT, body: {
      'order_id': orderId.toString(),
      'seller_id': sellerId.toString(),
      'transfer_comment': comment
    });
    return res is SuccessResponse;
  }

  Future<bool> checkOrderProductDelivery(OrderProductInfo product) async {
    var res = await _net.post(
        EndPoint.CHECK_PACKING, cacheEnabled: false, body: {
      'order_id': product.orderId.toString(),
      'item_id': product.itemId.toString()
    });

    return res is SuccessResponse;
  }

  Future<bool> productPacked(int orderId, int itemId) async {
    var res = await _net.post(EndPoint.ORDER_PRODUCT_PACKED, body: {
      'order_id': orderId.toString(),
      'item_id': itemId.toString(),
    });

    return res is SuccessResponse;
  }


  Future<OrderSentInfo> getOrderSendingInfo(int orderId, int sellerId) async {
    var res = await _net.post(
        EndPoint.GET_TRANSACTION, cacheEnabled: false, body: {
      'order_id': orderId.toString(),
      'seller_id': sellerId.toString()
    });

    if (res is SuccessResponse) {
      try {
        var order = OrderSentInfo.fromJson(
            List<Map<String, dynamic>>.from(res.data)[0]);
        return order;
      } catch (e, st) {
        print(e);
        print(st);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<bool> submitReturnProduct(OrderProductInfo product, String sessionId,
      int appUserId, String comment) async {
    var res = await _net.post(
        EndPoint.SUBMIT_PRODUCT_RETURN, cacheEnabled: false, body: {
      'session_id': sessionId,
      'order_id': product.orderId.toString(),
      'order_item_id': product.itemId.toString(),
      'app_user_id': appUserId,
      'srv_center_id': product.sellerId,
      'comment': comment,
    });

    return res is SuccessResponse;
  }

  PaidOrder parse(Map<String, dynamic> json, bool shopOrder) {
    var paidOrder = PaidOrder.fromJson(json);
    if (shopOrder) {
      return ShopPaidOrder.fromPaidOrder(
        paidOrder,
        /* json['order_transfer_time'] != null &&
            json['order_transfer_time'] != "NULL" &&
            json['order_transfer_time'] != "null" &&
            json['order_transfer_time'] != "Null",*/
      );
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
  OrderSentInfo sentInfo;

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

  factory ShopPaidOrder.fromPaidOrder(PaidOrder paidOrder /*, bool packed*/) {
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
      this.orderId);

  factory OrderProductInfo.fromJson(Map<String, dynamic> json, int orderId) {
    return OrderProductInfo(
        json['variant_id'],
        json['variant_code'],
        json['product_title_fa'],
        json['quantity'],
        json['unit_price'],
        json['seller'],
        json['srv_center_id'],
        json['seller_city'],
        json['item_id'],
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

class OrderSentInfo {
  final int id;
  final int orderId;
  final int sellerId;
  final Price tariff;
  final String orderDate;
  final bool sent;
  final String sentDate;

  OrderSentInfo(this.id, this.orderId, this.sellerId, this.tariff,
      this.orderDate, this.sent, this.sentDate);

  factory OrderSentInfo.fromJson(Map<String, dynamic> json) {
    return OrderSentInfo(
        json['id'],
        json['order_id'],
        json['seller_id'],
        Price(json['tariff_amount'].toString()),
        json['order_date'],
        json['order_transfer_time'] != null &&
            json['order_transfer_time'].toString() != null &&
            json['order_transfer_time'].toString() != 'null' &&
            json['order_transfer_time'].toString() != 'NULL' &&
            json['order_transfer_time'].toString() != 'Null',
        json['order_transfer_time']);
  }
}
