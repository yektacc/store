import 'package:store/store/products/product/product.dart';

class FavoriteIdentifier {
  final int id;
  final int productId;
  final String addedDate;

  FavoriteIdentifier(this.productId, this.id, this.addedDate);

  factory FavoriteIdentifier.fromJson(Map<String, dynamic> json) {
    return FavoriteIdentifier(
        json['prd_product_id'], json['id'], json['created_at']);
  }
}

class FavoriteProduct extends Product {
  final FavoriteIdentifier identifier;

  FavoriteProduct(Product product, this.identifier)
      : super(product.id, product.variantId, product.name,
            product.storeThumbnail, product.subCategory,
            brand: product.brand, imgUrl: product.imgUrl, price: product.price);
}
