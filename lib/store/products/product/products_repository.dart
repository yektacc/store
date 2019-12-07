import 'package:store/common/constants.dart';
import 'package:store/data_layer/netclient.dart';
import 'package:store/store/petstore/pet_store.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/structure/model.dart';

class ProductsRepository {
  final Net _net;

  ProductsRepository(this._net);

  Stream<List<Product>> load(Identifier identifier) async* {
    String petId;
    String catId;
    String subCatId;

    if (identifier is StructPet) {
      petId = identifier.id.toString();
    } else if (identifier is StructCategory) {
      petId = identifier.petId.toString();
      catId = identifier.id.toString();
    } else if (identifier is StructSubCategory) {
      petId = identifier.petId.toString();
      catId = identifier.catId.toString();
      subCatId = identifier.getId().toString();
    } else if (identifier is AllItems) {}

    var res = await _net.post(EndPoint.GET_PRODUCTS, body: {
      'maincategory_id': petId ?? '',
      'subcategory_id': catId ?? '',
      'type_id': subCatId ?? ''
    });

    final List<ProductJsonEntity> pageRes = [];
    final List<ProductJsonEntity> allPages = [];
    final List<Map<String, dynamic>> list = [];

    pageRes.clear();
    list.clear();

    if (res is SuccessResponse) {
      list.addAll(new List<Map<String, dynamic>>.from(res.data));
      pageRes.addAll(list.map((p) => ProductJsonEntity.fromJson(p)).toList());
      allPages.addAll(pageRes);

      List<Product> result = allPages.map((pr) {
        return new Product(
            pr.id,
            pr.variantId,
            pr.nameFA,
            StoreThumbnail(pr.shopId, pr.shopName),
            StructSubCategory(num.parse(pr.catId), "err", "err",
                num.parse(pr.petId), num.parse(pr.catId)),
            imgUrl: AppUrls.image_url + pr.img,
            price: Price(pr.salePrice),
            brand: pr.brand);
      }).toList();

      yield result;
    } else {
      yield [];
    }

/*    var res = await http.post(url + "&page=$page");

    var jsonBody = json.decode(res.body)['data'];*/

    /* var url =
        'http://51.254.65.54/epet24/public/api/getproducts?maincategory_id=${req.petId == null ? "" : req.petId}&subcategory_id=${req.catId == null ? "" : req.catId}&type_id=${req.typeId == null ? "" : req.typeId}';

    final List<ProductJsonEntity> pageRes = [];
    final List<ProductJsonEntity> allPages = [];
    final List<Map<String, dynamic>> list = [];
    var page = 1;

    pageRes.clear();
    list.clear();

    var res = await http.post(url + "&page=$page");

    var jsonBody = json.decode(res.body)['data'];

    list.addAll(new List<Map<String, dynamic>>.from(jsonBody));
    pageRes.addAll(list.map((p) => ProductJsonEntity.fromJson(p)).toList());
*/ /*
    print("all pages: " + pageRes.toString());
*/ /*
    allPages.addAll(pageRes);
    */ /*while (pageRes.isNotEmpty) {
      pageRes.clear();
      list.clear();
      page++;

      var res = await http.post(url + "&page=$page");
      var jsonBody = json.decode(res.body)['data'];
      list.addAll(new List<Map<String, dynamic>>.from(jsonBody));
      pageRes.addAll(list.map((p) => ProductJsonEntity.fromJson(p)).toList());
      allPages.addAll(pageRes);
      print("pageres: $pageRes");
    }*/ /*

    List<Product> result = allPages.map((pr) {
      return new Product(
          pr.id,
          pr.variantId,
          pr.nameFA,
          StoreThumbnail(pr.shopId, pr.shopName),
          StructSubCategory(num.parse(pr.catId), "err", "err",
              num.parse(pr.petId), num.parse(pr.catId)),
          imgUrl: "http://51.254.65.54/epet24/public/" + pr.img,
          price: Price(pr.salePrice),
          brand: pr.brand);
    }).toList();

    yield ProductRes(result);*/
  }

  Future<List<Product>> fetchPopular(Identifier identifier) async {
    return [];
  }
}

class ProductJsonEntity {
  final String id;
  final String variantId;
  final String nameFA;
  final String nameEN;
  final String code;
  final String img;
  final String score;
  final String originalPrice;
  final String salePrice;
  final bool exists;
  final String shopId;
  final String shopName;
  final String petId;
  final String catId;
  final String subCatId;
  final String brand;

  factory ProductJsonEntity.fromJson(Map<String, dynamic> productJson) {
    return ProductJsonEntity(
        productJson["product_id"].toString(),
        productJson["product_title_fa"],
        productJson["product_title_en"],
        productJson["product_code"].toString(),
        productJson["product_image"],
        productJson["product_score"].toString(),
        productJson["main_price"].toString(),
        productJson["sale_price"].toString(),
        productJson['is_exist'] == 1 ? true : false,
        productJson["center_name"],
        productJson["seller_center_id"].toString(),
        productJson["basecategory_id"].toString(),
        productJson["subcategory_id"].toString(),
        productJson["product_type_id"].toString(),
        productJson["product_brand"],
        productJson['variant_id'].toString());
  }

  ProductJsonEntity(
    this.id,
    this.nameFA,
    this.nameEN,
    this.code,
    this.img,
    this.score,
    this.originalPrice,
    this.salePrice,
    this.exists,
    this.shopName,
    this.shopId,
    this.petId,
    this.catId,
    this.subCatId,
    this.brand,
    this.variantId,
  );
}
