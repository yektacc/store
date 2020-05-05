import 'package:store/data_layer/netclient.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/store/location/provinces/model.dart';

import 'model.dart';

enum PetRequestType { LOST_FOUND, ADOPTION, All }

class LostPetsRepository {
  final ProvinceRepository _provinceBloc;
  final Net _net;

  LostPetsRepository(this._provinceBloc, this._net);

  Future<List<LostPet>> getPets(PetRequestType type) async {
    var param = '';

    switch (type) {
      case PetRequestType.LOST_FOUND:
        param += '1,2';
        break;
      case PetRequestType.ADOPTION:
        param += '3,4';
        break;
      case PetRequestType.All:
        break;
    }

    var res =
        await _net.post(EndPoint.GET_FC_LIST, body: {'request_type': param});

    if (res is SuccessResponse) {
      var lostPetsData = res.data;

      List<Map<String, dynamic>> lostPetsJsonList =
          new List<Map<String, dynamic>>.from(lostPetsData);

      List<LostPetRaw> lostPetsRaw =
          lostPetsJsonList.map((p) => LostPetRaw.fromJson(p)).toList();

      List<FCReqType> categories = await getCategories() ?? [];
      List<AnimalType> animalTypes = await getAnimalTypes() ?? [];

      return lostPetsRaw.map((rlp) {
        City city = UnknownCity();

        Province province = UnknownProvince();

        ProvinceCity provinceCity =
            _provinceBloc.getProvinceCity(rlp.provinceId, rlp.cityId);

        city = provinceCity.city;
        province = provinceCity.province;

        FCReqType reqType;

        categories.forEach((c) {
          if (c.id == rlp.requestTypeId) {
            reqType = c;
          }
        });

        AnimalType animalType;

        animalTypes.forEach((t) {
          if (t.id == rlp.amlTypeId) {
            animalType = t;
          }
        });
        return LostPet(
            imgUrl: rlp.pic1,
            city: city,
            lostDate: rlp.time,
            name: rlp.animalName,
            age: rlp.animalAge,
            reqType: reqType,
            animalType: animalType,
            description: rlp.description,
            gender: rlp.animalGender,
            phone: rlp.phoneNo,
            province: province,
            gift: rlp.requestGift,
            location: rlp.location);
      }).toList();
    } else {}
  }

  Future<List<FCReqType>> getCategories() async {
   /* String categoriesUrl =
        'http://51.254.65.54/epet24/public/api/getfccategories';

    var categoriesRes = await http.post(categoriesUrl);
    String categoriesBody = categoriesRes.body;

    print("lost pets categories url: " + categoriesUrl);
    print("lost pets categories result: " + categoriesRes.body.toString());*/

    var res = await _net.post(EndPoint.GET_FC_REQUEST_CATEGORY);

    if (res is SuccessResponse) {
      List<Map<String, dynamic>> categoriesJsonList =
          new List<Map<String, dynamic>>.from(res.data);

      var results =
      categoriesJsonList.map((c) => FCReqType.fromJson(c)).toList();

      return results;
    } else {
      return [];
    }
  }

  Future<List<AnimalType>> getAnimalTypes() async {
    var res = await _net.post(EndPoint.GET_ANIMAL_TYPES);

    if (res is SuccessResponse) {
      List<Map<String, dynamic>> animalsJsonList =
          new List<Map<String, dynamic>>.from(res.data);
      return animalsJsonList.map((a) => AnimalType.fromJson(a)).toList() ?? [];
    } else {
      return [];
    }
  }

  Future<bool> registerLostPet(
    LostPet lostPet,
    int userId,
  ) async {
/*
    String url = 'http://51.254.65.54/epet24/public/api/sendfcrequest?';
*/

    var response = await _net.post(EndPoint.ADD_FC_REQUEST, body: {
      'customer_id': userId,
      'request_type': lostPet.reqType.id,
      'aml_type_id': lostPet.animalType.id,
      'animal_name': lostPet.name,
      'animal_gender': lostPet.gender,
      'sterilization': lostPet.lostDate,
      'description': lostPet.description,
      'animal_age': lostPet.age,
      'province_id': lostPet.province.id,
      'city_id': lostPet.city.id,
      'time': lostPet.lostDate,
      'phone_number': lostPet.phone,
      'pic1': lostPet.imgUrl,
      'is_active': '',
      'valid_until': '',
      'requestgift': lostPet.gift,
      'animal_location': lostPet.location,
    });

    if (response is SuccessResponse) {
      return true;
    } else {
      return false;
    }

    /* String params = 'customer_id=$userId'
        '&request_type=${lostPet.reqType.id}'
        '&aml_type_id=${lostPet.animalType.id}'
        '&animal_name=${lostPet.name}'
        '&animal_gender=${lostPet.gender}'
        '&sterilization=${lostPet.lostDate}'
        '&description=${lostPet.description}'
        '&animal_age=${lostPet.age}'
        '&province_id=${lostPet.province.id}'
        '&city_id=${lostPet.city.id}'
        '&time=${lostPet.lostDate}'
        '&phone_number=${lostPet.phone}'
        '&pic1=${lostPet.imgUrl}'
        '&pic2='
        '&pic3='
        '&is_active=1'
        '&valid_until='
        '&requestgift=${lostPet.gift}'
        '&animal_location=${lostPet.location}';

    print(url + params);*/

    /*   var res = await http.post(url + params);
    String body = res.body;

    var data = json.decode(body)['data'];

    print('send fc request response:\n __________________________________\n' +
        data.toString());

    if (json.decode(data) == 0) {
      return true;
    } else
      return false;
      */
  }
}

class LostPetRaw {
  final int id;
  final int animalId;
  final int customerId;
  final int requestTypeId;
  final int amlTypeId;
  final String animalName;
  final int animalGender;
  final int sterilization;
  final String animalAge;
  final int provinceId;
  final int cityId;
  final String location;
  final String time;
  final String phoneNo;
  final String description;
  final String pic1;
  final String pic2;
  final String pic3;
  final bool isActive;
  final String validUnit;
  final String requestGift;

  LostPetRaw(
      this.id,
      this.animalId,
      this.customerId,
      this.requestTypeId,
      this.amlTypeId,
      this.animalName,
      this.animalGender,
      this.sterilization,
      this.animalAge,
      this.provinceId,
      this.cityId,
      this.location,
      this.time,
      this.phoneNo,
      this.description,
      this.pic1,
      this.pic2,
      this.pic3,
      this.isActive,
      this.validUnit,
      this.requestGift);

  factory LostPetRaw.fromJson(Map<String, dynamic> lostPetJson) {
    return LostPetRaw(
        lostPetJson['id'],
        lostPetJson['animal_id'],
        lostPetJson['customer_id'],
        lostPetJson['request_type'],
        lostPetJson['aml_type_id'],
        lostPetJson['animal_name'].toString(),
        lostPetJson['animal_gender'],
        lostPetJson['sterilization'],
        lostPetJson['animal_age'].toString(),
        lostPetJson['province_id'],
        lostPetJson['city_id'],
        lostPetJson['animal_location'].toString(),
        lostPetJson['time'].toString(),
        lostPetJson['phone_number'].toString(),
        lostPetJson['description'].toString(),
        lostPetJson['pic1'].toString(),
        lostPetJson['pic2'].toString(),
        lostPetJson['pic3'].toString(),
        lostPetJson['is_active'] == 1 ? true : false,
        lostPetJson['valid_until'],
        lostPetJson['requestgift'].toString());
  }
}

class FCReqType {
  final int id;
  final String name;
  final String image;
  final int fee;

  FCReqType(this.id, this.name, this.image, this.fee);

  factory FCReqType.fromJson(Map<String, dynamic> categoryJson) {
    return FCReqType(categoryJson['id'], categoryJson['category_name'],
        categoryJson['category_image'], categoryJson['fee']);
  }
}

class AnimalType {
  final int id;
  final String title;

  AnimalType(this.id, this.title);

  factory AnimalType.fromJson(Map<String, dynamic> animalTypesJson) {
    return AnimalType(animalTypesJson['id'], animalTypesJson['title']);
  }
}
