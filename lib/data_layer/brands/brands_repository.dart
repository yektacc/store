import 'dart:core';

import '../netclient.dart';

class BrandsRepository {
  final Net _client;

  BrandsRepository(this._client);

  Stream<List<Brand>> fetch() async* {
    PostResponse response = await _client.post(EndPoint.GET_BRANDS);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      yield list.map(parse).toList();
    } else {
      yield [];
    }
  }

  Brand parse(Map<String, dynamic> json) {
    return Brand(json['id'], json['brand_name_fa'], json['brand_name_en'],
        json['brand_description'], json['brand_logo']);
  }
}

class Brand {
  final int id;
  final String nameFa;
  final String nameEn;
  final String description;
  final String logoUrl;

  Brand(this.id, this.nameFa, this.description, this.logoUrl, this.nameEn);
}
