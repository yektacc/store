import 'package:store/data_layer/netclient.dart';
import 'package:store/store/location/provinces/model.dart';

class DeliveryPriceRepository {
  final Net _client;

  DeliveryPriceRepository(this._client);

  Future<int> getPrice(City city, Province province, double weight) async {
    PostResponse response = await _client.post(
      EndPoint.GET_POST_TARIFF,
      body: {'city_id': city.id, 'province_id': province.id}
    );
    if (response is SuccessResponse) {

      var tariffJson = List<Map<String, dynamic>>.from(response.data);
      Tariff t = Tariff.fromJson(tariffJson [0]);

      if (weight > t.tariff2) {
        return (t.tariff1 + (weight - t.tariff2.toDouble()) * t.tariff3).toInt();
      } else {
        return t.tariff1;
      }
    } else {
      throw Exception('error getting postal price');
    }
  }

  Tariff parse(Map<String, dynamic> json) {
    return Tariff.fromJson(json);
  }
}

class Tariff {
  final int id;
  final int provinceId;
  final int cityId;
  final int tariff1;
  final int tariff2;
  final int tariff3;

  Tariff(this.id, this.provinceId, this.cityId, this.tariff1, this.tariff2,
      this.tariff3);

  factory Tariff.fromJson(Map<String, dynamic> json) {
    return Tariff(
      json['id'],
      json['province_id'],
      json['city_id'],
      json['tariff1'],
      json['tariff2'],
      json['tariff3'],
    );
  }
}
