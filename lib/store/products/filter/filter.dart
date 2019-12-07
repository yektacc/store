import 'package:meta/meta.dart';
import 'package:store/store/products/product/product.dart';

enum SortingType { BY_PRICE_ASC, BY_PRICE_DES, BY_RATE, BY_LOCATION, NONE }

class FilterData {
  List<String> brands;
  Price minPrice;
  Price maxPrice;
  SortingType sort;

  FilterData({this.brands, this.minPrice, this.maxPrice, this.sort});

  List<Product> filter(List<Product> products) {
    return [products[0], products[1]];
  }

  bool hasBrand(String brand) {
    return brands.contains(brand);
  }

  bool isEmpty() {
    return (brands == null || brands.isEmpty) &&
        minPrice == null &&
        maxPrice == null &&
        sort == null;
  }

  @override
  String toString() => "Filter Data: min price: $minPrice, max price: $maxPrice, brands: $brands, sort: $sort ";

  FilterData copyWith(
      {List<String> brands,
      Price minPrice,
      Price maxPrice,
      int petId,
      int catId,
      int subCatId,
      SortingType sort}) {
    return FilterData(
        brands: brands ?? this.brands,
        minPrice: minPrice ?? this.brands,
        maxPrice: maxPrice ?? this.brands,
        /*  petId: petId ?? this.brands,
        catId: catId ?? this.brands,
        subCatId: subCatId ?? this.brands,*/
        sort: sort ?? this.brands);
  }
}

@immutable
class Price extends Comparable<Price> {
  final int amount;

  String formattedCounted(int count) {
    return "${getNumberIndexing(amount * count)} تومان ";
  }

  String formatted() => "${getNumberIndexing(amount)} تومان ";

  Price(String str) : amount = num.parse(str, (e) => -1);

  @override
  String toString() => "PRICE: amount: $amount";

  @override
  int compareTo(Price other) {
    if (this.amount > other.amount) {
      return 1;
    } else if (this.amount == other.amount) {
      return 0;
    } else {
      return -1;
    }
  }

  static String parseFormatted(int amount) {
    return "${getNumberIndexing(amount)} تومان ";
  }

  static String getNumberIndexing(int number) {
    String output = (number).toString();

    int length = output.length;

    int commasCount = length % 3 == 0 ? length ~/ 3 - 1 : length ~/ 3;

    for (int i = 1; i <= commasCount; i++) {
      output = output.substring(0, ((length) - (i * 3))) +
          "," +
          output.substring(((length) - (i * 3)), length + i - 1);
    }

    return output;
  }
}

@immutable
class PriceNotAvailable extends Price {
  PriceNotAvailable() : super('-1');

}
