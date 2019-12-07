import 'package:store/store/products/detail/product_detail_model.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRepository {
  final ProductDetailRepository _detailRepo;
  final List<DetailedProduct> list = [];

  FavoriteRepository(this._detailRepo);

  Future<List<DetailedProduct>> getAll(String sessionId) async {
    var products = await _getProductIDs();
    var mappedList = products.map((productId) async {
      return await _detailRepo.load(productId.toString());
    }).toList();

    List<DetailedProduct> list = await Future.wait(mappedList);

    return list;
  }

  Future<bool> add(DetailedProduct product, String sessionId) async {
    var products = await _getProductIDs();
    print("kkokokkk" + products.toString());

    if (products.contains(product.id)) {
      return true;
    } else {
      products.add(int.parse(product.id));
      _saveProducts(products);
      return true;
    }
  }

  Future<bool> remove(int productId, String sessionId) async {
    _removeProduct(productId);
    return true;
  }

  final key1 = 'items';

  Future<List<int>> _getProductIDs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key1)) {
      List<String> items = prefs.getStringList(key1);
      return items.map((item) => int.parse(item)).toList();
    } else {
      return [];
    }
  }

  _saveProducts(List<int> products) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key1, products.map((p) => p.toString()).toList());
  }

  _removeProduct(int id) async {
    var products = await _getProductIDs();
    if(products.contains(id)){
      products.removeWhere((item) => item == id);
      await _saveProducts(products);
    }

  }
}
