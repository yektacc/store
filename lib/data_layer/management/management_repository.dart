import 'dart:core';

import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/management/model.dart';
import 'package:store/store/management/shop/seller_add_product_page.dart';

import '../netclient.dart';

class ManagementRepository {
  final Net _client;

  ManagementRepository(this._client);

  Future<List<CenterIdentifier>> loginSeller(String email,
      String password) async {
    PostResponse response = await _client.post(EndPoint.SELLER_LOGIN,
        body: {'email': email, 'password': password}, cacheEnabled: false);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list.map(_parseLogin).toList();
    } else {
      return [];
    }
  }

  Future<Shop> getFullShop(ShopIdentifier identifier) async {
    PostResponse response = await _client.post(EndPoint.GET_PRODUCT_OF_SELLER,
        body: {'seller_id': identifier.id.toString()}, cacheEnabled: false);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return Shop(identifier, list.map(_parseProduct).toList());
    } else {
      return Shop(identifier, []);
    }
  }

  /*Future<Shop> getOrders(ShopIdentifier identifier) async {
    PostResponse response = await _client.post(EndPoint.GET_PRODUCT_OF_SELLER,
        body: {'seller_id': identifier.sellerId.toString()},
        cacheEnabled: false);

    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return Shop(identifier, list.map(_parseProduct).toList());
    } else {
      return Shop(identifier, []);
    }
  }*/

  Future<bool> editProductOfSeller(List<ShopProduct> items) async {
    var mappedList = items.map((item) async {
      var res = await _client.post(EndPoint.EDIT_SELLER_PRODUCT,
          body: {
            'id': item.prdSaleId,
            'sale_price':
            (item.salePrice != null ? item.salePrice.toString() : ''),
            'stock_quantity': (item.stockQuantity != null
                ? item.stockQuantity.toString()
                : ''),
            'maximum_orderable': (item.maximumOrderable != null
                ? item.maximumOrderable.toString()
                : '')
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

  CenterIdentifier _parseLogin(Map<String, dynamic> json) {
    switch (json['center_type']) {
      case 1:
        return ServiceIdentifier(json['id'] /*, json['seller_id']*/,
            json['center_name'], json['city_id'], json['chat_is_active'] == 1);
        break;
      case 4:
        return ShopIdentifier(json['id'] /*, json['seller_id']*/,
            json['center_name'], json['city_id']);
        break;
      default:
        throw (Exception('center type not valid :  $json'));
    }
  }

  ShopProduct _parseProduct(Map<String, dynamic> json) {
    return ShopProduct(
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
      json['quantity'],
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

  Future<bool> logout() async {
    await _removeUser();
    return true;
  }

  final key1 = 'sm_mail';
  final key2 = 'sm_password';
  final key3 = 'sm_type';

  Future<ManagerUser> readManagerUser() async {
    print('this function was called');
    WidgetsFlutterBinding.ensureInitialized();

    final prefs = await SharedPreferences.getInstance();

    ManagerType type;

    try {
      var index = int.parse(prefs.getString(key3));
      type = ManagerType.values[index];
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return null;
    }

    final user = ManagerUser(
      prefs.getString(key1) ?? "err",
      prefs.getString(key2) ?? "err",
      type,
    );

    print('read user from shared prefs:' + user.toString());

    if (user.email == "err" || user.password == "err" || type == null) {
      print(
          'failed reading manager user ${user.email} ${user.password} ${user
              .type}');
      return null;
    }
    return user;
  }

  saveManagerUser(ManagerUser user) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key1, user.email);
    prefs.setString(key2, user.password);
    prefs.setString(key3, user.type.index.toString());

    print(
        'saved manager user email: ${user.email}  pass: ${user
            .password} type: ${user.type}');
  }

  _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key1);
    prefs.remove(key2);
    prefs.remove(key3);
  }
}

class ShopProduct {
  final int id;
  final int prdSaleId;
  final int variantId;
  final int sellerId;
  final String name;
  final String img;
  final String brand;
  int shippingTime;
  final int guarantyId;
  final int originalPrice;
  int salePrice;
  final int saleDiscount;
  int maximumOrderable;
  final int isBounded;
  int stockQuantity;
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

  ShopProduct(
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
    return other is ShopProduct &&
        this.id == other.id &&
        this.variantId == other.variantId &&
        this.sellerId == other.sellerId;
  }

  @override
  int get hashCode {
    return hash3(this.id, this.variantId, this.sellerId);
  }
}

//  Future<bool> editProductOfSeller(List<PrdItem> items) async {
//    var mappedList = items.map((prdItem) async {
//      var res = await _client.post(EndPoint.EDIT_SELLER_PRODUCT,
//          body: {
//            'id': prdItem.prd.prdSaleId,
//            'sale_price':
//            prdItem.newPrice != null ? prdItem.newPrice.toString() : '',
//            'stock_quantity':
//            prdItem.newCount != null ? prdItem.newCount.toString() : '',
//            'maximum_orderable':
//            prdItem.maxOrder != null ? prdItem.maxOrder.toString() : ''
//          },
//          cacheEnabled: false);
//      return res is SuccessResponse;
//    }).toList();
//
//    var allRes = await Future.wait(mappedList);
//    return allRes.fold(true, (prv, res) => res && prv);
//
//    /*  var res = await _client.post(EndPoint.EDIT_SELLER_PRODUCT,
//        body: {'id': prdSaleId, 'sale_price': newPrice});
//
//    if (res is SuccessResponse) {
//      return true;
//    } else {
//      return false;
//    }*/
//  }

//  Future<List<ProductImage>> getAllPricingProducts() async {
//    PostResponse response = await _client.post(EndPoint.GET_PRICING_PRODUCTS);
//    if (response is SuccessResponse) {
//      var list = List<Map<String, dynamic>>.from(response.data);
//      return list.map((json) => ProductImage.fromJson(json)).toList();
//    } else {
//      return [];
//    }
//  }
