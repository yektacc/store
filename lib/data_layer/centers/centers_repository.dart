import 'dart:async';
import 'dart:core';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/netclient.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/store/location/provinces/model.dart';

import '../../services/centers/model.dart';

class CentersRepository {
  final Net net;
  final ProvinceRepository _provinceRepo;

  CentersRepository(this._provinceRepo, this.net);

  Future<List<CenterItem>> getCenters(CenterFilter filter) async {
    String param;

    var fetchType = filter.type;

    String provinceId =
    filter.provinceId == -1 ? '' : filter.provinceId.toString();
    String cityId = filter.cityId == -1 ? '' : filter.cityId.toString();
    String sort = filter.sort == CenterSortType.SCORE ? 'best_score' : 'newest';

    switch (fetchType) {
      case CenterFetchType.CLINICS:
        param = '1';
        break;
      case CenterFetchType.PENSION_BARBER:
        param = '2,3';
        break;

      case CenterFetchType.STORE:
        param = '4';
        break;
      case CenterFetchType.ALL:
        break;
    }

    var response = await net.post(EndPoint.GET_CENTERS, body: {
      'center_type': param,
      'province_id': provinceId,
      'city_id': cityId,
      'center_name': filter.name,
      'filter_type': sort
    });

    if (response is SuccessResponse) {
      List<Map<String, dynamic>> jsonList =
          new List<Map<String, dynamic>>.from(response.data);

      List<CenterRaw> rawCenters = jsonList.map((center) {
        return CenterRaw.fromJson(center);
      }).toList();

      List<CenterItem> allCenters = [];

      List<CenterType> types = await getCenterTypes();

      allCenters.addAll(rawCenters.map((centerRaw) {
        City city;

        Province province;

        ProvinceCity provinceCity = _provinceRepo.getProvinceCity(
            centerRaw.provinceId, centerRaw.cityId);

        city = provinceCity.city;
        province = provinceCity.province;

        CenterType type =
            types.firstWhere((type) => type.id == centerRaw.typeId);

        var latLng = LatLng(36.6830, 48.5087);

        try {
          latLng = centerRaw.location == ""
              ? LatLng(36.6830, 48.5087)
              : LatLng(double.parse(centerRaw.location.split(',')[0]),
              double.parse(centerRaw.location.split(',')[1]));
        } catch (e) {
          print('Error parsing center location : ${centerRaw.location} \n $e');
          latLng = LatLng(36.6830, 48.5087);
        }

        return CenterItem(
            centerRaw.name ?? "",
            centerRaw.remainedAddress ?? "",
            centerRaw.id ?? "",
            centerRaw.phoneNo ?? "",
            centerRaw.logo != null ? AppUrls.image_url + centerRaw.logo : "",
            centerRaw.description ?? "",
            centerRaw.typeId ?? "",
            centerRaw.score ?? "",
            type.name ?? "",
            type.image ?? "",
            centerRaw.website ?? "",
            centerRaw.email ?? "",
            latLng,
            province ?? UnknownProvince(),
            city ?? UnknownCity(),
            [centerRaw.wd1, centerRaw.wd2, centerRaw.wd3],
            centerRaw.departmentId);
      }).toList());

      if (fetchType == CenterFetchType.CLINICS) {
        List<CenterItem> clinics =
            allCenters.where((center) => center.typeId == 1).toList();
        print("Center Repo response clinics: $clinics");
        return clinics;
      } else if (fetchType == CenterFetchType.ALL) {
        return allCenters;
      } else if (fetchType == CenterFetchType.PENSION_BARBER) {
        return allCenters
            .where((center) => center.typeId == 2 || center.typeId == 3)
            .toList();
      } else if (fetchType == CenterFetchType.STORE) {
        List<CenterItem> stores =
            allCenters.where((center) => center.typeId == 4).toList();
        print("Centers Repo stores: $stores");
        return stores;
      } else {
        throw Exception('fetch type not found');
      }
    } else {
      return [];
    }
  }

  Future<List<CenterType>> getCenterTypes() async {
    var response = await net.post(EndPoint.GET_CENTER_TYPES);

    if (response is SuccessResponse) {
      List<Map<String, dynamic>> list =
          new List<Map<String, dynamic>>.from(response.data);
      List<CenterType> types =
          list.map((type) => CenterType.fromJson(type)).toList() ?? [];
      return types;
    } else {
      return [];
    }
  }

  Future<List<String>> getCenterImgUrl(String centerId) async {
    var response = await net
        .post(EndPoint.GET_CENTER_PICTURES, body: {'center_id': centerId},
        cacheEnabled: false);
    if (response is SuccessResponse) {
      List<Map<String, dynamic>> centerImages =
          new List<Map<String, dynamic>>.from(response.data);

      if (centerImages.isNotEmpty && centerImages[0].containsKey('image')) {
        List<String> list = centerImages.map((img) => img['image'].toString())
            .toList();
        print('just before return' + list.toString());
        return list;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<String> getCityNameByCenterId(
      CenterFetchType centerType, int id) async {
    List<CenterItem> centers = await getCenters(CenterFilter(centerType));

    CenterItem center;
    if (centers.map((c) => c.id).contains(id)) {
      center = centers.firstWhere((c) => c.id == id);
    }

    return center != null ? center.city.name : '';
  }

  Future<bool> submitCenterScore(
      int centerId, int score, String sessionId) async {
    var response = await net.post(EndPoint.SEND_CENTER_SCORE, body: {
      'srv_center_id': centerId.toString(),
      'session_id': sessionId,
      'score': score.toString()
    });
    if (response is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }
}

/*
class Service {
  final int id;
  final String name;
  final String categoryId;

  Service(this.id, this.name, this.categoryId);

  factory Service.fromJson(Map<String, dynamic> serviceJson) {
    return Service(serviceJson['id'], serviceJson['service_name'],
        serviceJson['category_id']);
  }
}
*/
