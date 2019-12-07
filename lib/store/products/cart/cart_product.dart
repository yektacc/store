import 'package:store/store/petstore/pet_store.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/products/product/product.dart';

class CartProduct {
  final Product product;
  int count;

  int addOne() {
    count++;
    return count;
  }

  int removeOne() {
    count--;
    return count;
  }

  CartProduct(this.product, this.count);
}

class CartProductAlt {
  final int count;

  final String productId;
  final String variantId;
  final StoreThumbnail _storeThumbnail;

  final String name;
  final Price price;

  CartProductAlt(this.productId, this.variantId, this._storeThumbnail,
      this.name, this.price, this.count);

  factory CartProductAlt.fromProduct(Product product, int count) =>
      CartProductAlt(product.id, product.variantId, product.storeThumbnail,
          product.name, product.price, count);
}
