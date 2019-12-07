import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import '../netclient.dart';

/*
part 'tagged_products_repository.g.dart';
*/

/*
class TagProductsRepo {
  final Net _client;

  TagProductsRepo(this._client);

  Future<List<TagProduct>> fetch() async {
    PostResponse response =
        await _client.post(EndPoint.GET_SELLER_PRODUCTS_TAG);
    if (response is SuccessResponse) {
      print(response.toString());
      var list = List<Map<String, dynamic>>.from(response.data);
      return list.map((json) => TagProduct.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}

@JsonSerializable()
class TagProduct {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'is_active')
  final int isActive;

  @JsonKey(name: 'seller_id')
  final int sellerId;

  @JsonKey(name: 'product_id')
  final int productId;

  @JsonKey(name: 'tag_id')
  final int tagId;

  @JsonKey(name: 'start_datetime')
  final String startTime;

  @JsonKey(name: 'stop_datetime')
  final String endTime;

  @JsonKey(name: 'price')
  final int price;

  @JsonKey(name: 'tag_price')
  final int tagPrice;

  @JsonKey(name: 'seller_description')
  final String sellerDescription;

  TagProduct(
      this.id,
      this.isActive,
      this.sellerId,
      this.tagId,
      this.startTime,
      this.endTime,
      this.price,
      this.tagPrice,
      this.sellerDescription,
      this.productId);

  factory TagProduct.fromJson(Map<String, dynamic> json) =>
      _$TagProductFromJson(json);

  Map<String, dynamic> toJson() => _$TagProductToJson(this);
}
*/
