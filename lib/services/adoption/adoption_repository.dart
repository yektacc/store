import 'package:store/store/location/provinces/model.dart';

import 'model.dart';

class AdoptionPetsRepository {
  static List<City> cities = [City("زنجان", 1, 0, 0), City("تهران", 1, 0, 0)];

  List<AdoptionPet> _adoptionPets = [
    AdoptionPet("1", cities[0]),
    AdoptionPet("1", cities[1]),
    AdoptionPet("1", cities[0]),
    AdoptionPet("1", cities[1]),
    AdoptionPet("1", cities[1]),
  ];

  Future<List<AdoptionPet>> getAll() {
    return Future.delayed(Duration(seconds: 1), () => _adoptionPets);
  }

  Future<bool> registerAdoptionPet(AdoptionPet adoptionPet) {
/*    if(clinic.id == "") {
      clinic.id = (_adoptionPets.length + 1).toString();
    }*/
    _adoptionPets.add(adoptionPet);

    return Future.delayed(Duration(seconds: 1), () => true);
  }
}
