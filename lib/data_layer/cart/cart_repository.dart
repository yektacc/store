import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:store/store/products/cart/cart_product.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';

import '../netclient.dart';

part 'cart_repository.g.dart';


// abcde
class CartRepository {
  final Net _client;
  final ProductDetailRepository _detailRepo;
  CartRepository(this._client, this._detailRepo);

  Future<List<CartItem>> fetch(String sessionId) async {
    PostResponse response = await _client
        .post(EndPoint.GET_SHOPPING_CART, body: {'session_id': sessionId});
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list.map((json) => CartItem.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  String _getCartItemFormatted(CartProductWithSaleItem item) {
    return '{ "item_id" : ${item.saleItemId} , "quantity" : ${item.cartProduct.count}}';
  }

  Future<String> sendCart(
      String sessionId, List<CartProduct> cartProducts, String total) async {
    var mappedList = cartProducts.map((cartProduct) async {
      var saleItemId = await _detailRepo.getProductSaleItemId(
          int.parse(cartProduct.product.id),
          int.parse(cartProduct.product.variantId),
          int.parse(cartProduct.product.storeThumbnail.id));

      return CartProductWithSaleItem(cartProduct, saleItemId);
    }).toList();

    List<CartProductWithSaleItem> list = await Future.wait(mappedList);

    String cartItems = list.fold(
        '',
        (prev, cp) =>
            _getCartItemFormatted(cp) + (prev == '' ? '' : ',') + prev);

    String cartItemsParam = '{ "items" :[$cartItems]}';

    PostResponse response = await _client.post(EndPoint.SEND_SHOPPING_CART,
        body: {
          'session_id': sessionId,
          'cart_items': cartItemsParam,
          'total_amount': total
        },
        cacheEnabled: false);
    if (response is SuccessResponse) {
      return response.data['order_code'];
    } else {
      return '';
    }
  }

  Future<bool> emptyCart(String sessionId, String orderCode) async {
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
  }
}

@JsonSerializable()
class CartItem {
  @JsonKey(name: 'id')
  final int id;

  CartItem(this.id);

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

class CartProductWithSaleItem {
  final CartProduct cartProduct;
  final int saleItemId;

  CartProductWithSaleItem(this.cartProduct, this.saleItemId);
}
