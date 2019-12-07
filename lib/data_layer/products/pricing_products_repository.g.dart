// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_products_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductImage _$PricingProductFromJson(Map<String, dynamic> json) {
  return ProductImage(
    json['product_picture'] as String,
  );
}

Map<String, dynamic> _$PricingProductToJson(ProductImage instance) =>
    <String, dynamic>{
      'product_picture': instance.imageURL,
    };
