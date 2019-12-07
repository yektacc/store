import 'package:store/store/petstore/pet_store.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/structure/model.dart';
import 'package:quiver/core.dart';

enum ProductTag {
  BEST_SELLER,
  HAS_DISCOUNT,
  DISCOUNT_COUPON,
}

/*class ExtendedProduct {
  final String id;

  final List<Product> products;

  ExtendedProduct(this.products, this.id);

  Product getCheapest() {
    Product cheapest;
    products.forEach((p) {
      if (cheapest == null) {
        cheapest = p;
      } else {
        if (cheapest.price.compareTo(p.price) > 0) {
          cheapest = p;
        }
      }
    });
    return cheapest;
  }

  Product getByVarSellerId(String variantId, String sellerId) {
    if (products.contains(
        (p) => p.variantId == variantId && p.storeThumbnail.id == sellerId)) {
      return products.firstWhere(
          (p) => p.variantId == variantId && p.storeThumbnail.id == sellerId);
    } else {
      print('223333333333' + products.toString());
      throw 'element not found: variant: $variantId  sellerId: $sellerId';
    }
  }

  addProduct(Product product) {
    products.add(product);
  }

*/ /*final String productId;
  final String name;
  final String imgUrl;
  final StructSubCategory subCategory;
  final String brand;
  final List<Variant> variants;

  ExtendedProduct(this.productId, this.name, this.imgUrl, this.subCategory,
      this.brand, this.variants);*/ /*
}*/

class Variant {
  final String variantId;
  final Price price;
  final Price originalPrice;
  final StoreThumbnail storeThumbnail;

  Variant(this.variantId, this.price, this.originalPrice, this.storeThumbnail);
}

class Product {
  final String id;
  final String variantId;
  final String name;
  final String imgUrl;
  final Price price;
  final StructSubCategory subCategory;
  final String brand;

  final StoreThumbnail storeThumbnail;

  @override
  bool operator ==(other) {
    return other is Product &&
        other.id == this.id &&
        other.variantId == this.variantId &&
        other.storeThumbnail.id == this.storeThumbnail.id;
  }

  @override
  int get hashCode {
    return hash3(this.id, this.variantId, this.storeThumbnail.id);
  }

  final List<ProductTag> tags = [];

  @override
  String toString() {
    return "PRODUCT: id: $id   name: $name   price: $price   |*|   ";
  }

  Product(
      this.id, this.variantId, this.name, this.storeThumbnail, this.subCategory,
      {this.imgUrl, this.price,  this.brand}) {
    if (this.price != null) {
      tags.add(ProductTag.HAS_DISCOUNT);
    }
  }
}

class Prop {
  final PropType type;
  final String value;

  Prop(this.type, this.value);

  @override
  bool operator ==(other) {
    return other is Prop &&
        this.type == other.type &&
        this.value == other.value;
  }

  @override
  String toString() {
    return "PROP: type: $type   value: $value";
  }
}

class PropType {
  final int id;
  final String name;

  PropType(this.id, this.name);

  @override
  bool operator ==(other) {
    return other.runtimeType == PropType &&
        other is PropType &&
        this.id == other.id;
  }

  @override
  int get hashCode {
    return 1;
  }

  @override
  String toString() {
    return "PROPTYPE: id: $id  name: $name   |*|";
  }
}
