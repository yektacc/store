import 'package:store/data_layer/netclient.dart';
import 'package:store/store/products/detail/product_detail_model.dart';

import 'model.dart';

class FavoriteRepository {
//  final ProductDetailRepository _detailRepo;
  final Net _net;

//  final List<FavoriteProduct> list = [];

  FavoriteRepository(this._net);

  Future<List<FavoriteIdentifier>> getAll(int appUserID) async {
    var res = await _net.post(EndPoint.GET_FAVORITES,
        body: {
          'app_user_id': appUserID.toString(),
        },
        cacheEnabled: false);

    if (res is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(res.data);

      return list.map((json) => FavoriteIdentifier.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<bool> add(DetailedProduct product, int appUserID) async {
    var res = _net.post(EndPoint.ADD_FAVORITE,
        body: {
          'app_user_id': appUserID.toString(),
          'basecategory_id': product.subCategory.petId.toString(),
          'subcategory_id': product.subCategory.catId.toString(),
          'type_id': product.subCategory.id.toString(),
          'prd_product_id': product.id.toString()
        },
        cacheEnabled: false);

    return res is SuccessResponse;
  }

  Future<bool> remove(int favoriteId, int appUserID) async =>
      await _net.post(EndPoint.DELETE_FAVORITE,
          body: {'app_user_id': appUserID, 'id': favoriteId},
          cacheEnabled: false) is SuccessResponse;

//  final key1 = 'items';

/* Future<List<int>> _getProductIDs() async {
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
    if (products.contains(id)) {
      products.removeWhere((item) => item == id);
      await _saveProducts(products);
    }
  }*/
}
