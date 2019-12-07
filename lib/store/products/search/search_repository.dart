import 'package:store/store/products/product/product.dart';

class SearchRepository {
  Future<List<Product>> fetch(String query) async {
//    "https://www.magicalearscollectibles.com/thumbnail.asp?file=assets/images/7512002529657.jpg&maxx=300&maxy=0"

    var size = PropType(1, "size");
    var weight = PropType(2, "weight");
    var expiration = PropType(3, "expiration");

    await Future.delayed(Duration(milliseconds: 300));
    return [
      /* Product("1", "a",
          imgUrl: "https://png.pngtree.com/svg/20170915/product_1170775.png",
          price: Price("1700")),
      Product("2", "b",
          imgUrl: "_aaa",
          props: [
            Prop(expiration, "2003"),
            Prop(size, "Small"),
            Prop(weight, "35")
          ],
          price: Price("600")),
      Product("3", "c",
          imgUrl: "_aaa",
          props: [
            Prop(expiration, "2000"),
            Prop(size, "Medium"),
            Prop(weight, "2")
          ],
          price: Price("1000")),*/
    ];
  }
}

class SearchResult {
  final Product product;

  SearchResult(this.product);
}
