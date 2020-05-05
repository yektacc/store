import 'dart:async';

import 'package:store/common/constants.dart';
import 'package:store/data_layer/netclient.dart';
import 'package:store/store/petstore/pet_store.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/products/product/products_repository.dart';
import 'package:store/store/structure/model.dart';
import 'package:store/store/structure/repository.dart';

class SpecialProductsRepository {
  final Net _net;
  final StructureRepository _structureRepository;

  SpecialProductsRepository(this._net, this._structureRepository);

  Future<List<Product>> getSpecialProducts(SpecialProductType type) {
    switch (type) {
      case SpecialProductType.BEST_SELLER:
        return _getSellerProducts();
        break;
      case SpecialProductType.NEWEST:
        return _getNewestProducts();
        break;
      default:
        return Future.value([]);
    }
  }

  Future<List<Product>> _getNewestProducts() async {
    final response = await _net.post(EndPoint.GET_FILTERED_PRODUCTS,
        body: {'filter_type': 'newest'});

    if (response is SuccessResponse) {
      List<Map<String, dynamic>> list =
          new List<Map<String, dynamic>>.from(response.data['data']);

      List<Product> products = list.map((json) {
            ProductJsonEntity pr = ProductJsonEntity.fromJson(json);
            return new Product(
                pr.id,
                pr.variantId,
                pr.nameFA,
                StoreThumbnail(pr.shopId, pr.shopName),
                StructSubCategory(
                    pr.catId,
                    pr.subCatName,
                    "",
                    pr.petId,
                    pr.catId,
                    pr.petName,
                    pr.catName),
                imgUrl: AppUrls.image_url + pr.img,
                price: Price(pr.salePrice),
                brand: pr.brand);
          }).toList() ??
          [];

      return products;
    } else
      return [];
  }

  Future<List<Product>> _getSellerProducts() async {
    final response = await _net
        .post(
        EndPoint.GET_FILTERED_PRODUCTS, body: {'filter_type': 'best_sale'});

    if (response is SuccessResponse) {
      List<Map<String, dynamic>> list =
          new List<Map<String, dynamic>>.from(response.data['data']);

      List<Product> products = list.map((json) {
            ProductJsonEntity pr = ProductJsonEntity.fromJson(json);
            return new Product(
                pr.id,
                pr.variantId,
                pr.nameFA,
                StoreThumbnail(pr.shopId, pr.shopName),
                StructSubCategory(
                    pr.catId,
                    pr.subCatName,
                    "",
                    pr.petId,
                    pr.catId,
                    pr.petName,
                    pr.catName),
                imgUrl: AppUrls.image_url + pr.img,
                price: Price(pr.salePrice),
                brand: pr.brand);
          }).toList() ??
          [];

      return products;
    } else
      return [];
  }
}

enum SpecialProductType { BEST_SELLER, NEWEST }
