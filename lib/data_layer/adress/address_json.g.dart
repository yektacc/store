// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressData _$AddressDataFromJson(Map<String, dynamic> json) {
  return AddressData(
    json['address_id'] as int,
    json['transferee_name'] as String,
    json['transferee_mobile_number'] as String,
    json['province_name'] as String,
    json['city_name'] as String,
    json['city_id'] as int,
    json['province_id'] as int,
    json['district_name'] as String,
    json['remained'] as String,
      json['postal_code'].toString(),
      json['editable'] as int
  );
}

Map<String, dynamic> _$AddressDataToJson(AddressData instance) =>
    <String, dynamic>{
      'address_id': instance.id,
      'transferee_name': instance.name,
      'transferee_mobile_number': instance.phone,
      'province_name': instance.provinceName,
      'city_name': instance.cityName,
      'district_name': instance.districtName,
      'remained': instance.remained,
    };
