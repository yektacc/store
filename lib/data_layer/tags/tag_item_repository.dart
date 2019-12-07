import 'dart:core';

import 'package:store/common/constants.dart';
import 'package:store/data_layer/netclient.dart';
import 'package:store/store/petstore/pet_store.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/structure/model.dart';

class TagItem {
  final Tag tag;
  final List<Product> products;

  TagItem(this.tag, this.products);
}

class TagProduct {
  final int productId;
  final int variantId;
  final int sellerId;
  final String sellerName;
  final int cityId;
  final int salePrice;
  final int stockQuantity;
  final String titleFa;
  final String img;
  final bool exists;
  final int tagId;
  final bool tagActive;
  final DateTime tagStart;
  final DateTime tagFinish;

  TagProduct(
      this.productId,
      this.variantId,
      this.sellerId,
      this.sellerName,
      this.cityId,
      this.salePrice,
      this.stockQuantity,
      this.titleFa,
      this.img,
      this.exists,
      this.tagId,
      this.tagActive,
      this.tagStart,
      this.tagFinish);

  factory TagProduct.fromJson(Map<String, dynamic> json) {
    return TagProduct(
      json['product_id'],
      json['variant_id'],
      json['seller_id'],
      json['center_name'],
      json['city_id'],
      json['sale_price'],
      json['stock_quantity'],
      json['product_title_fa'],
      AppUrls.image_url + json['product_main_image'],
      json['is_exist'] == 1,
      json['tag_id'],
      json['tag_is_active'] == 1,
      DateTime.parse(json['tag_starttime'].toString()),
      DateTime.parse(json['tag_stoptime'].toString()),
    );
  }
}

class TagsRepository {
  final Net _client;
  final ProductDetailRepository _detailRepo;

  TagsRepository(this._client, this._detailRepo);

  Future<List<Tag>> _getTags() async {
    PostResponse response = await _client.post(EndPoint.GET_PRODUCTS_TAG);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list.map(parse).toList();
    } else {
      return [];
    }
  }

  Tag parse(Map<String, dynamic> json) {
    return Tag(json['id'], json['tag_name'], json['description']);
  }

  Future<List<TagProduct>> _getTagProducts(Tag tag) async {
    PostResponse response = await _client.post(EndPoint.GET_SELLER_PRODUCTS_TAG,
        body: {'tag_id': tag.id.toString(), 'is_active': '1'});

    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data['data']);
      var products = list.map((item) => TagProduct.fromJson(item)).toList();
      return products;
    } else {
      return [];
    }
  }

  Future<List<TagItem>> getTagItems() async {
    List<Tag> tags = await _getTags();

    List<TagProduct> tagProducts = await _getTagProducts(tags[0]);

    List<Product> products = tagProducts.map((tagProduct) {
      return Product(
          tagProduct.productId.toString(),
          tagProduct.variantId.toString(),
          tagProduct.titleFa,
          StoreThumbnail(tagProduct.sellerId.toString(), tagProduct.sellerName),
          StructSubCategory(1, '', '', 1, 1),
          imgUrl: tagProduct.img,
          price: Price(tagProduct.salePrice.toString()));
    }).toList();

    return [TagItem(tags[0], products)];
  }
}

class Tag {
  final int id;
  final String title;
  final String description;

  Tag(this.id, this.description, this.title);
}
