import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store/store/location/provinces/model.dart';

/*abstract class Location {
  LatLng getLocation();
}*/

class Location {
  final City city;

  Location(this.city);

  LatLng getLocation() {
    return LatLng(city.lat, city.long);
  }
}

class DetailedLocation extends Location {
  final LatLng fineLocation;

  DetailedLocation(this.fineLocation, City city) : super(city);

  @override
  LatLng getLocation() {
    return fineLocation;
  }
}
