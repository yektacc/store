/*
import 'package:store/store/products/product/product.dart';

import 'filter.dart';

class FilterInteractor {
  FilterInteractor();

  List<FilterData> filterOptions(List<Product> products) {
    List<Prop> allProps = [];

    products.forEach((product) {
      allProps.addAll(product.props);
    });

    List<FilterData> options = [];

    allProps.forEach((prop) {
      if (options.map((f) => f.type).contains(prop.type)) {
        options.firstWhere((f) => f.type == prop.type).add(prop.value);
      } else {
        options.add(FilterData(prop.type, values: [prop.value]));
      }
    });

    return options;
  }

  List<Product> filterProducts(
      List<Product> products, List<FilterData> filters) {
    List<Product> filteredProducts = [];

    filters.forEach((filter) {
      filteredProducts.addAll(products.where((p) => p.matchFilter(filter)));
    });

    return filteredProducts;
  }
}
*/
