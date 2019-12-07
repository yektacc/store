import 'dart:async';
import 'dart:core';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store/data_layer/netclient.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/store/location/provinces/model.dart';

import '../../services/centers/model.dart';

class CentersRepository {
  final Net net;
  final ProvinceRepository _provinceRepo;

  CentersRepository(this._provinceRepo, this.net);

  Future<List<CenterItem>> getCenters(CenterFetchType fetchType) async {
    String param;

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

    var response =
        await net.post(EndPoint.GET_CENTERS, body: {'center_type': param});

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

        var latLng = centerRaw.location == ""
            ? LatLng(36.6830, 48.5087)
            : LatLng(double.parse(centerRaw.location.split(',')[0]),
                double.parse(centerRaw.location.split(',')[1]));

        return CenterItem(
            centerRaw.name ?? "",
            centerRaw.remainedAddress ?? "",
            centerRaw.id ?? "",
            centerRaw.phoneNo ?? "",
            centerRaw.logo ?? "",
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
            centerRaw.wd1,
            centerRaw.departmentId);
      }).toList());

      if (fetchType == CenterFetchType.CLINICS) {
        List<CenterItem> clinics =
            allCenters.where((center) => center.typeId == 1).toList();
        print("clinics: $clinics");
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
        print("stores: $stores");
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

  Future<String> getCenterImgUrl(String centerId) async {
    var response = await net
        .post(EndPoint.GET_CENTER_PICTURES, body: {'center_id': centerId});
    if (response is SuccessResponse) {
      List<Map<String, dynamic>> centerImages =
          new List<Map<String, dynamic>>.from(response.data);

      if (centerImages.isNotEmpty && centerImages[0].containsKey('image')) {
        return centerImages[0]['image'];
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  Future<String> getCityNameByCenterId(
      CenterFetchType centerType, int id) async {
    List<CenterItem> centers = await getCenters(centerType);

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

class WorkingDay {
  final String _days;
  final String from;
  final String to;

  WorkingDay(this._days, this.from, this.to);

  List<String> get days {
    return _days.split(';').map((s) => s.substring(2)).toList();
  }
}

class CenterRaw {
  final int id;
  final int sellerId;
  final int userId;
  final String name;
  final int typeId;
  final int departmentId;
  final int provinceId;
  final int cityId;
  final int districtId;
  final String remainedAddress;
  final String phoneNo;
  final String phoneFax;
  final WorkingDay wd1;
  final WorkingDay wd2;
  final WorkingDay wd3;
  final String logo;
  final String description;
  final String score;
  final String website;
  final String email;
  final String location;
  final bool isActive;
  final String serviceIds;

  CenterRaw(
      this.id,
      this.sellerId,
      this.userId,
      this.name,
      this.typeId,
      this.departmentId,
      this.provinceId,
      this.cityId,
      this.districtId,
      this.remainedAddress,
      this.phoneNo,
      this.phoneFax,
      this.wd1,
      this.wd2,
      this.wd3,
      this.logo,
      this.description,
      this.score,
      this.website,
      this.email,
      this.location,
      this.isActive,
      this.serviceIds);

  factory CenterRaw.fromJson(Map<String, dynamic> centerJson) {
    return CenterRaw(
        centerJson['id'],
        centerJson['seller_id'],
        centerJson['user_id'],
        centerJson['center_name'],
        centerJson['center_type'],
        centerJson['department_id'],
        centerJson['province_id'],
        centerJson['city_id'],
        centerJson['district_id'],
        centerJson['remaind'],
        centerJson['center_phone'].toString(),
        centerJson['phone_fax'].toString(),
        WorkingDay(
            centerJson['workingday1'].toString(),
            centerJson['timefrom1'].toString(),
            centerJson['timeto1'].toString()),
        WorkingDay(
            centerJson['workingday2'].toString(),
            centerJson['timefrom2'].toString(),
            centerJson['timeto2'].toString()),
        WorkingDay(
            centerJson['workingday3'].toString(),
            centerJson['timefrom3'].toString(),
            centerJson['timeto3'].toString()),
        centerJson['center_logo'],
        centerJson['center_description'],
        centerJson['center_score'].toString(),
        centerJson['center_website'],
        centerJson['center_email'],
        centerJson['ne_location'].toString(),
        centerJson['is_active'] == 1 ? true : false,
        /*centerJson['services']*/
        "");
  }
}

class CenterType {
  final int id;
  final String name;
  final String image;
  final String fee;

  CenterType(this.id, this.name, this.image, this.fee);

  factory CenterType.fromJson(Map<String, dynamic> categoryJson) {
    return CenterType(categoryJson['id'], categoryJson['category_name'],
        categoryJson['category_image'], categoryJson['fee'].toString());
  }
}

enum CenterFetchType { CLINICS, PENSION_BARBER, STORE, ALL }

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
