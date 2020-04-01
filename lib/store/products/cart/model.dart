import 'package:store/store/location/provinces/model.dart';
import 'package:store/store/petstore/pet_store.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/products/product/product.dart';

class Cart {
  final List<CartProduct> products;

  int get total {
    int total = 0;

    products.forEach((cp) {
      total += cp.count * cp.product.price.amount;
    });

    return total;
  }

  int get count {
    int count = 0;
    products.forEach((cp) {
      count += cp.count;
    });

    return count;
  }

  Cart(this.products);
}

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

class WeightProduct extends CartProduct {
  final int unit;
  final double weight;
  final String unitName;

  WeightProduct(CartProduct cartProduct, this.weight, this.unit)
      : this.unitName = unit == 1 ? 'کیلوگرم' : 'گرم',
        super(cartProduct.product, cartProduct.count);
}

class DeliveryItem {
  final City city;
  final Province province;
  final List<WeightProduct> products;
  final int sellerId;

  bool matchCity(City city) {
    return city.id == this.city.id;
  }

  double getTotalWeight() {
    double total = products.fold(
        0.0,
            (pr, wp) =>
        pr + (wp.unit == 1 ? wp.weight : wp.weight / 1000) * wp.count);

    return total;
  }

  String getTotalWeightString() {
    var grams = getTotalWeight() * 1000;

    return grams % 1000 == 0
        ? getTotalWeight().toInt().toString() + ' کیلوگرم '
        : (getTotalWeight() * 1000).round().toString() + ' گرم ';
  }

  DeliveryItem(this.city, this.province, this.products, this.sellerId);
}

class PricedDeliveryItem extends DeliveryItem {
  final Price price;

  PricedDeliveryItem(DeliveryItem di, this.price)
      : super(di.city, di.province, di.products, di.sellerId);
}

class DeliveryInfo {
  final List<PricedDeliveryItem> items;

//  final Price totalPrice;

  Price get totalPrice =>
      Price(items
          .map((pdi) => pdi.price.amount)
          .fold(0, (prev, dip) => prev + dip)
          .toString());

  DeliveryInfo(this.items /*, this.totalPrice*/);
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
