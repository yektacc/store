import 'package:quiver/core.dart';

class Store {
  final String id;
  final String name;
  String loc = "default location";
  final bool hasCoupon;
  final bool hasOff;
  Rating rating;

  Store(this.id, this.name,
      {this.hasCoupon = false, this.hasOff = false, Rating rating}) {
    if (this.rating == null) {
      this.rating = Rating(0);
    } else {
      this.rating = rating;
    }
  }
}

class StoreThumbnail {
  final String id;
  final String name;

  StoreThumbnail(this.id, this.name);

  @override
  int get hashCode {
    return hash2(id, name);
  }

  @override
  bool operator ==(other) {
    return other is StoreThumbnail && this.id == other.id;
  }
}

class Rating extends Comparable<Rating> {
  double value;

  Rating(double value) {
    if (value > 5 || value < 0) {
      throw (Exception("RATING: error rating in invalid range. value: $value"));
    } else {
      value = this.value;
    }
  }

  @override
  int compareTo(Rating other) {
    if (this.value > other.value) {
      return 1;
    } else if (this.value < other.value) {
      return -1;
    } else {
      return 0;
    }
  }
}
