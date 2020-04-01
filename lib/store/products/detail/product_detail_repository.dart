import 'package:store/data_layer/netclient.dart';
import 'package:store/store/petstore/pet_store.dart';
import 'package:store/store/products/detail/product_detail_model.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/structure/model.dart';

class ProductDetailRepository {
  final Net _net;

  ProductDetailRepository(this._net);

  Future<DetailedProduct> load(String id) async {
    var res =
        await _net.post(EndPoint.GET_PRODUCT_DETAIL, body: {'product_id': id});

    if (res is SuccessResponse) {
      List<Map<String, dynamic>> detailList =
          new List<Map<String, dynamic>>.from(res.data['detail']);

      List<Map<String, dynamic>> categoryList =
          new List<Map<String, dynamic>>.from(res.data['category']);

      Map<String, dynamic> categoryJson = categoryList[0];

      StructSubCategory subCategory = StructSubCategory(
          categoryJson['type_id'],
          categoryJson['type_name'],
          '',
          categoryJson['basecategory_id'],
          categoryJson['subcategory_id'],
          categoryJson['basecategory_name'],
          categoryJson['subcategory_name']);

      DetailedProduct detail =
          DetailedProduct.fromJson(detailList.first, subCategory);
      return detail;
    }
  }

  Future<bool> sendScore(int saleItemId, String sessionId, int score) async {
    var res = await _net.post(EndPoint.SEND_PRODUCT_SCORE, body: {
      'prd_sale_item_id': saleItemId.toString(),
      'score': score.toString(),
      'app_user_id': sessionId
    });

    if (res is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }

  Future<DetailSeller> getSeller(
    int id,
    int variantId,
    int sellerId,
  ) async {
    var detail = await load(id.toString());
    var variant =
        detail.variants.firstWhere((v) => v.id == variantId.toString());
    var seller =
        variant.sellers.firstWhere((s) => s.shopId == sellerId.toString());

    return seller;
  }

  Future<Product> getProductById(String id,
      {String variantId, String sellerId}) async {
    DetailedProduct detail = await load(id);
    ProductVariant variant;
    DetailSeller seller;

    if (variantId != null) {
      variant =
          detail.variants.firstWhere((variant) => variantId == variant.id);

      if (sellerId != null) {
        seller =
            variant.sellers.firstWhere((seller) => seller.shopId == sellerId);
      }
    }

    return Product(
        id,
        variantId ?? '',
        detail.titleFa,
        StoreThumbnail(sellerId ?? '', seller != null ? seller.name : ''),
        detail.subCategory,
        price: seller != null ? seller.salePrice : PriceNotAvailable());
  }

  Future<int> getProductSaleItemId(
      int productId, int variantId, int sellerId) async {
    var seller = await getSeller(productId, variantId, sellerId);
    return seller.saleItemId;
  }

  Future<List<Product>> getProductListFromDetailList(
      List<DetailedProduct> detailedProducts) async {
    var favoriteList =
        detailedProducts.map((dp) async => getProductById(dp.id));

    List<Product> products = await Future.wait(favoriteList);

    return products;
  }
}
