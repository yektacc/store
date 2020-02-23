import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store/store/location/provinces/model.dart';

class CenterItem {
  final int id;
  final String name;
  final String phone;
  final String logoUrl;
  final String description;
  final int typeId;
  final String score;
  final String typeName;
  final String typeImg;
  final String website;
  final String email;
  final LatLng location;
  final Province province;
  final City city;
  final String address;

/*
  final List<Service> services;
*/
  final List<WorkingDay> workingDays;
  final int departmentId;

/*
  final String doctorsName;
*/
/*
  final List<ClinicService> services;
*/

  CenterItem(this.name,
      this.address,
      this.id,
      this.phone,
      this.logoUrl,
      this.description,
      this.typeId,
      this.score,
      this.typeName,
      this.typeImg,
      this.website,
      this.email,
      this.location,
      this.province,
      this.city,
      /*this.services,*/ this.workingDays,
      this.departmentId);
}

class ClinicService {
  final String name;

  ClinicService(this.name);
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

  CenterRaw(this.id,
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

class WorkingDay {
  final String _days;
  final String from;
  final String to;

  static const List<String> daysOfWeek = [
    'شنبه',
    'یک‌شنبه',
    'دوشنبه',
    'سه‌شنبه',
    'جهارشنبه',
    'پنج‌شنبه',
    'جمعه'
  ];

  WorkingDay(this._days, this.from, this.to);

  List<String> get days {
    List<String> result = [];
    try {
      result = _days.split(';').map((s) => daysOfWeek[int.parse(s)]).toList();
    } catch (e) {}
    return result;
  }
}

class CenterFilter {
  final CenterFetchType type;
  final int provinceId;
  final int cityId;
  final String name;
  final CenterSortType sort;

  CenterFilter(this.type,
      {this.provinceId = -1, this.cityId = -1, this.name = '', this.sort = CenterSortType
          .SCORE});


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

enum CenterSortType { NEWEST, SCORE }
