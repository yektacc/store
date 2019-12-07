class Province {
  final String name;
  final int id;
  final List<City> cities;

  factory Province.fromJson(Map<String, dynamic> provinceJson) {
    return Province(
        provinceJson["province_name"],
        provinceJson["province_id"],
        (provinceJson["cities"] as List)
            .map((value) => City.fromJson(value))
            .toList());
  }

  Province(this.name, this.id, this.cities);

  @override
  String toString() {
    return name;
  }


}

class City {
  final String name;
  final int id;
  final double lat;
  final double long;
  final int zoom;

  factory City.fromJson(Map<String, dynamic> cityJson) {
    return City(
        cityJson["city_name"],
        cityJson["city_id"],
        double.parse(cityJson["citycenter_N"].toString(), (e) => 0),
        double.parse(cityJson["citycenter_E"].toString(), (e) => 0));
  }

  City(this.name, this.id, this.lat, this.long, {int zoom = 13})
      : this.zoom = zoom;

  @override
  String toString() {
    return name;
  }


}

class UnknownCity extends City {
  UnknownCity() : super("شهر", -1, 0, 0);
}

class UnknownProvince extends Province {
  UnknownProvince() : super("استان",-1,[]);
}
