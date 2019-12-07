import 'dart:core';

import 'package:store/common/constants.dart';
import 'package:store/data_layer/products/pricing_products_repository.dart';
import 'package:store/store/shop_management/seller_add_product_page.dart';
import 'package:store/store/shop_management/seller_detail_page.dart';
import 'package:quiver/core.dart';

import '../netclient.dart';

class ShopRepository {
  final Net _client;

  ShopRepository(this._client);

  Future<List<Shop>> loginSeller(String userName, String password) async {
    PostResponse response = await _client.post(EndPoint.SELLER_LOGIN,
        body: {'email': userName, 'password': password}, cacheEnabled: false);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list.map(parseLogin).toList();
    } else {
      return [];
    }
  }

  Future<List<SellerPrd>> getProductsOfSeller(int sellerId) async {
    PostResponse response = await _client.post(EndPoint.GET_PRODUCT_OF_SELLER,
        body: {'seller_id': sellerId.toString()}, cacheEnabled: false);

    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list.map(parseProduct).toList();
    } else {
      return [];
    }
  }

  Future<bool> editProductOfSeller(List<PrdItem> items) async {
    var mappedList = items.map((prdItem) async {
      var res = await _client.post(EndPoint.EDIT_SELLER_PRODUCT,
          body: {
            'id': prdItem.prd.prdSaleId.toString(),
            'sale_price': prdItem.newPrice.toString()
          },
          cacheEnabled: false);
      return res is SuccessResponse;
    }).toList();

    var allRes = await Future.wait(mappedList);
    return allRes.fold(true, (prv, res) => res && prv);

    /*  var res = await _client.post(EndPoint.EDIT_SELLER_PRODUCT,
        body: {'id': prdSaleId, 'sale_price': newPrice});

    if (res is SuccessResponse) {
      return true;
    } else {
      return false;
    }*/
  }

  Future<bool> submitProduct(PricingProduct product, String sellerId) async {
    PostResponse response = await _client.post(EndPoint.ADD_SELLER_PRODUCT,
        body: {
          'variant_id': product.product.variantId.toString(),
          'seller_id': sellerId,
          'shipment_time': product.shippingTime.toString(),
          'guaranty_id': '1',
          'main_price': '0',
          'sale_price': product.salePrice.toString(),
          'sale_discount': '0',
          'maximum_orderable': product.maximumOrderable.toString(),
          'is_bounded': '1',
          'stock_quantity': product.count.toString(),
          'is_exist': '1',
          'tag_is_active': '1',
          'sale_description': '1'
        },
        cacheEnabled: false);
    if (response is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> submitProducts(
      List<PricingProduct> products, String sellerId) async {
    var submitProducts =
        products.map((p) async => await submitProduct(p, sellerId)).toList();

    List<bool> results = await Future.wait(submitProducts);

    var resultBool = true;

    results.forEach((r) {
      if (r == false) {
        resultBool = false;
      }
    });

    return resultBool;
  }

  Future<List<ProductImage>> getAllPricingProducts() async {
    PostResponse response = await _client.post(EndPoint.GET_PRICING_PRODUCTS);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list.map((json) => ProductImage.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Shop parseLogin(Map<String, dynamic> json) {
    return Shop(
        json['id'], json['seller_id'], json['center_name'], json['city_id']);
  }

  SellerPrd parseProduct(Map<String, dynamic> json) {
    return SellerPrd(
      json['product_id'],
      json['prd_sale_item_id'],
      json['variant_id'],
      json['seller_shop_id'],
      json['product_title_fa'],
      AppUrls.image_url + json['product_image'],
      json['product_brand'],
      json['shipment_time'],
      json['guaranty_id'],
      json['main_price'],
      json['sale_price'],
      json['sale_discount'],
      json['maximum_orderable'],
      json['is_bounded'],
      json['stock_quantity'],
      json['description'],
      json['is_exist'] == 1,
      json['sale_count'],
      json['visit_count'],
      json['tag_id'],
      json['tag_price'],
      json['tag_is_active'] == 1,
      json['tag_starttime'],
      json['tag_stoptime'],
      json['basecategory_name'],
      json['subcategory_name'],
      json['product_type_name'],
    );
  }
}

class SellerPrd {
  final int id;
  final int prdSaleId;
  final int variantId;
  final int sellerId;
  final String name;
  final String img;
  final String brand;
  final int shippingTime;
  final int guarantyId;
  final int originalPrice;
  final int salePrice;
  final int saleDiscount;
  final int maximumOrderable;
  final int isBounded;
  final int stockQuantity;
  final String description;
  final bool exists;
  final int saleCount;
  final int visitCount;
  final int tagId;
  final int tagPrice;
  final bool isTagActive;
  final String tagStartTime;
  final String tagEndTime;
  final String petName;
  final String categoryName;
  final String subCatName;

  SellerPrd(
      this.id,
      this.prdSaleId,
      this.variantId,
      this.sellerId,
      this.name,
      this.img,
      this.brand,
      this.shippingTime,
      this.guarantyId,
      this.originalPrice,
      this.salePrice,
      this.saleDiscount,
      this.maximumOrderable,
      this.isBounded,
      this.stockQuantity,
      this.description,
      this.exists,
      this.saleCount,
      this.visitCount,
      this.tagId,
      this.tagPrice,
      this.isTagActive,
      this.tagStartTime,
      this.tagEndTime,
      this.petName,
      this.categoryName,
      this.subCatName);

  @override
  bool operator ==(other) {
    return other is SellerPrd &&
        this.id == other.id &&
        this.variantId == other.variantId &&
        this.sellerId == other.sellerId;
  }

  @override
  int get hashCode {
    return hash3(this.id, this.variantId, this.sellerId);
  }
}

class Shop {
  final int id;
  final int sellerId;
  final String centerName;
  final int cityId;

  Shop(this.id, this.sellerId, this.centerName, this.cityId);
}
