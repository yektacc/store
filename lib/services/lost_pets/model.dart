import 'package:store/store/location/provinces/model.dart';

import 'lost_pets_repository.dart';

class LostPet {
  String name;
  FCReqType reqType;
  AnimalType animalType;
  String age;
  String imgUrl;
  String phone;
  City city;
  Province province;
  String lostDate;
  String description;
  int gender;
  String location;
  String gift;

  LostPet({
      this.imgUrl,
      this.city,
      this.lostDate,
      this.name,
      this.age,
      this.reqType,
      this.animalType,
      this.description,
      this.gender,
      this.phone,
      this.province,
      this.gift,
      this.location});

/*factory LostPet.fromJson(Map<String, dynamic> lostPetJson) {
    return LostPet(
        lostPetJson["animal_image"].toString(),
        City("زنجان", 0, 0, 0),
        lostPetJson["time"],
        lostPetJson["animal_name"],
        lostPetJson["animal_age"],
        lostPetJson["animal_type"],
        lostPetJson["description"],
        lostPetJson["gender"],
        lostPetJson["phone"]);
  }*/
}
