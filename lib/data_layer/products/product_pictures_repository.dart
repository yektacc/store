import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import '../netclient.dart';

part 'product_pictures_repository.g.dart';

class ProductPicturesRepository {
  final Net _client;

  ProductPicturesRepository(this._client);

  Future<List<ProductPicture>> fetch(int productId) async {
    PostResponse response = await _client
        .post(EndPoint.GET_PRODUCT_PICS, body: {'product_id': productId.toString()});
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list.map((json) => ProductPicture.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}

@JsonSerializable()
class ProductPicture {
  @JsonKey(name: 'product_picture')
  final String imageURL;

  ProductPicture(this.imageURL);

  factory ProductPicture.fromJson(Map<String, dynamic> json) =>
      _$ProductPictureFromJson(json);

  Map<String, dynamic> toJson() => _$ProductPictureToJson(this);
}
