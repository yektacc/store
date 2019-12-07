import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store/store/location/provinces/model.dart';

import '../../data_layer/centers/centers_repository.dart';

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
  final WorkingDay workingDay1;
  final int departmentId;

/*
  final String doctorsName;
*/
/*
  final List<ClinicService> services;
*/

  CenterItem(
    this.name,
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
    /*this.services,*/ this.workingDay1,this.departmentId
  );
}

class ClinicService {
  final String name;

  ClinicService(this.name);
}
