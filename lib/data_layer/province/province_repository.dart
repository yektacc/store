import 'dart:collection';

import 'package:store/data_layer/netclient.dart';
import 'package:store/store/location/provinces/model.dart';

class ProvinceRepository {
  final Map<int, Province> _cache = HashMap();
  final Net _net;

  ProvinceRepository(this._net);

  Future<List<Province>> getAllAsync() async {
    /*if (_cache.isNotEmpty) {
      return _cache.values.toList();
    } else {*/
    var res = await _net.post(EndPoint.GET_PROVINCE_CITY);
    if (res is SuccessResponse) {
      List<Map<String, dynamic>> list =
          new List<Map<String, dynamic>>.from(res.data);

      List<Province> provinces = list.map((p) => Province.fromJson(p)).toList();

      provinces.forEach((province) {
        _cache.putIfAbsent(province.id, () => province);
      });

      return provinces;
    } else {
      return [];
    }
  }

  List<Province> getAll() {
    if (_cache.isNotEmpty) {
      return _cache.values.toList();
    } else {
      throw Exception('province cache is not initialized');
    }
  }

  String getCityName(int cityId) {
    return _getCityName(_cache.values.toList(), cityId);
  }

  String _getCityName(List<Province> provinces, int cityId) {
    String cityName = "نامشخص";
    provinces.forEach((prv) => prv.cities.forEach((cty) {
          if (cty.id == cityId) {
            cityName = cty.name;
          }
        }));
    return cityName;
  }

  ProvinceCity _getProvinceCity(
      List<Province> provinces, int provinceId, int cityId) {
    Province province = UnknownProvince();
    City city = UnknownCity();
    provinces.forEach((prv) {
      if (prv.id == provinceId) {
        province = prv;
        prv.cities.forEach((cty) {
          if (cty.id == cityId) {
            city = cty;
          }
        });
      }
    });
    return ProvinceCity(province, city);
  }

  ProvinceCity getProvinceCity(int provinceId, int cityId) {
    if (_cache.isNotEmpty) {
      return _getProvinceCity(_cache.values.toList(), provinceId, cityId);
    } else
      throw Exception("cache isn't initialized");
    /*else {
      List<Province> provinces = await getAll();
      return _getProvinceCityName(provinces, provinceId, cityId);
    }*/
  }
}

class ProvinceCity {
  final Province province;
  final City city;

  ProvinceCity(this.province, this.city);
}
