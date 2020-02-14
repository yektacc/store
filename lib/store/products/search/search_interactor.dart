import 'package:store/store/products/product/product.dart';

class SearchInteractor {
  SearchInteractor();

  List<Product> search(List<Product> allProducts, String query) {
    return allProducts
        .where((product) => product.name.contains(query))
        .toList();
  }
}
