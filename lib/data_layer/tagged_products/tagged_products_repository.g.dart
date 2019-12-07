/*
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tagged_products_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagProduct _$TagProductFromJson(Map<String, dynamic> json) {
  return TagProduct(
    json['id'] as int,
    json['is_active'] as int,
    json['seller_id'] as int,
    json['tag_id'] as int,
    json['start_datetime'] as String,
    json['stop_datetime'] as String,
    json['price'] as int,
    json['tag_price'] as int,
    json['seller_description'] as String,
    json['product_id'] as int,
  );
}

Map<String, dynamic> _$TagProductToJson(TagProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_active': instance.isActive,
      'seller_id': instance.sellerId,
      'product_id': instance.productId,
      'tag_id': instance.tagId,
      'start_datetime': instance.startTime,
      'stop_datetime': instance.endTime,
      'price': instance.price,
      'tag_price': instance.tagPrice,
      'seller_description': instance.sellerDescription,
    };
*/
