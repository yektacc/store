import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import '../netclient.dart';

part 'pricing_products_repository.g.dart';

class ProductPicturesRepo {
  final Net _client;

  ProductPicturesRepo(this._client);


}

@JsonSerializable()
class ProductImage {
  @JsonKey(name: 'product_picture')
  final String imageURL;

  ProductImage(this.imageURL);

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$PricingProductFromJson(json);

  Map<String, dynamic> toJson() => _$PricingProductToJson(this);
}
