import 'package:quiver/core.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/structure/model.dart';

class DetailedProduct {
  final String id;
  final String titleFa;
  final String code;
  final String brand;
  final String positivePoints;
  final String negativePoints;
  final String weight;
  final String unit;
  final String size;
  final String score;
  final String description;
  final List<ProductVariant> variants;
  final StructSubCategory subCategory;

  factory DetailedProduct.fromJson(Map<String, dynamic> detailJson, StructSubCategory subCategory) {
    return DetailedProduct(
        detailJson["product_id"].toString(),
        detailJson["product_title_fa"],
        detailJson["product_code"].toString(),
        detailJson["product_brand"].toString(),
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

  DetailedProduct(this.id,
      this.titleFa,
      this.code,
      this.brand,
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
    return hash2(id, 'detail');
  }

  @override
  bool operator ==(other) {
    return other.runtimeType == DetailedProduct &&
        other is DetailedProduct &&
        other.id == this.id;
  }

  DetailSeller getSellerById(int shopId) {
    DetailSeller foundSeller;

    variants.forEach((variant) {
      variant.sellers.forEach((seller) {
        if (seller.shopId == shopId.toString()) {
          seller = seller;
        }
      });
    });

    return foundSeller;
  }
}

class ProductVariant {
  final String id;
  final String color;

  final List<DetailSeller> sellers;

  factory ProductVariant.fromJson(Map<String, dynamic> variantJson) {
    return ProductVariant(
        variantJson["variant_id"].toString(),
        variantJson["product_color"],
        (variantJson["shops"] as List)
            .map((value) =>
            DetailSeller.fromJson(
                variantJson["variant_id"].toString(), value))
            .toList());
  }

  ProductVariant(this.id, this.color, this.sellers);
}

class DetailSeller {
  final String shopId;
  final String variantId;
  final int saleItemId;
  final String name;
  final String city;
  final String shippingTime;
  final Price salePrice;
  final String discount;
  final String guarantee;
  final int saleCount;
  final int stockQuantity;

  final int maxOrder;
  final bool available;

  factory DetailSeller.fromJson(String variantId, Map<String, dynamic> sellerJson) {
    return DetailSeller(
        sellerJson['product_seller_id'].toString(),
        variantId,
        sellerJson["product_sale_item_id"],
        sellerJson["product_shop_name"],
        sellerJson["product_shop_city"],
        sellerJson["product_shipment_time"].toString(),
        Price(sellerJson["product_sale_price"].toString()),
        sellerJson["product_sale_discount"].toString(),
        sellerJson["product_guarantee"],
        sellerJson["sale_count"],
        sellerJson["stock_quantity"],
        sellerJson["product_maximum_orderable"].toString() == 'null'
            ? 1
            : sellerJson["product_maximum_orderable"],
        sellerJson["product_is_exist"].toString() == "موجود" ? true : false);
  }

  DetailSeller(this.shopId,
      this.variantId,
      this.saleItemId,
      this.name,
      this.city,
      this.shippingTime,
      this.salePrice,
      this.discount,
      this.guarantee,
      this.saleCount,
      this.stockQuantity,
      this.maxOrder,
      this.available);
}
