import 'package:store/store/products/product/product.dart';

class SearchInteractor {
  SearchInteractor();

  List<Product> search(List<Product> allProducts, String query) {
    print('adsfasdfasldkfkkkk');

    return allProducts
        .where((product) => product.name.contains(query))
        .toList();
  }
}
