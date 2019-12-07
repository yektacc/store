import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/structure/model.dart';
import 'package:quiver/core.dart';

class DetailedProduct {
  final String id;
  final String titleFa;
  final String code;
  final String positivePoints;
  final String negativePoints;
  final String weight;
  final String unit;
  final String size;
  final String score;
  final String description;
  final List<ProductVariant> variants;
  final StructSubCategory subCategory;

  factory DetailedProduct.fromJson(
      Map<String, dynamic> detailJson, StructSubCategory subCategory) {
    return DetailedProduct(
        detailJson["product_id"].toString(),
        detailJson["product_title_fa"],
        detailJson["product_code"].toString(),
        detailJson["product_positive_points"].toString(),
        detailJson["product_nagative_points"].toString(),
        detailJson["product_weight"].toString(),
        detailJson["product_unit"],
        detailJson["product_size"].toString(),
        detailJson["product_score"].toString(),
        detailJson["product_description"],
        (detailJson["variants"] as List)
            .map((value) => ProductVariant.fromJson(value))
            .toList(),
        subCategory);
  }


  DetailedProduct(
      this.id,
      this.titleFa,
      this.code,
      this.positivePoints,
      this.negativePoints,
      this.weight,
      this.unit,
      this.size,
      this.score,
      this.description,
      this.variants,
      this.subCategory);

  @override
  int get hashCode {
    return hash2(id,'detail');
  }

  @override
  bool operator ==(other) {
    return other.runtimeType == DetailedProduct &&
        other is DetailedProduct &&
        other.id == this.id;
  }
}

class ProductVariant {
  final String id;
  final String color;

  final List<SellerProduct> sellers;

  factory ProductVariant.fromJson(Map<String, dynamic> variantJson) {
    return ProductVariant(
        variantJson["variant_id"].toString(),
        variantJson["product_color"],
        (variantJson["shops"] as List)
            .map((value) => SellerProduct.fromJson(
                variantJson["variant_id"].toString(), value))
            .toList());
  }

  ProductVariant(this.id, this.color, this.sellers);
}

class SellerProduct {
  final String shopId;
  final String variantId;
  final int saleItemId;
  final String name;
  final String city;
  final String shippingTime;
  final Price salePrice;
  final String discount;
  final String guarantee;
  final String maxOrder;
  final bool available;

  factory SellerProduct.fromJson(
      String variantId, Map<String, dynamic> sellerJson) {
    return SellerProduct(
        sellerJson['product_seller_id'].toString(),
        variantId,
        sellerJson["product_sale_item_id"],
        sellerJson["product_shop_name"],
        sellerJson["product_shop_city"],
        sellerJson["product_shipment_time"].toString(),
        Price(sellerJson["product_sale_price"].toString()),
        sellerJson["product_sale_discount"].toString(),
        sellerJson["product_guarantee"],
        sellerJson["product_maximum_orderable"].toString(),
        sellerJson["product_is_exist"].toString() == "موجود" ? true : false);
  }

  SellerProduct(
      this.shopId,
      this.variantId,
      this.saleItemId,
      this.name,
      this.city,
      this.shippingTime,
      this.salePrice,
      this.discount,
      this.guarantee,
      this.maxOrder,
      this.available);
}
