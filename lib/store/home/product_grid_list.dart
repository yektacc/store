import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/products/product/product_grid_item.dart';

class ProductGridList extends StatefulWidget {
  final String title;
  final Future<List<Product>> getProducts;

  ProductGridList(this.title, this.getProducts);

  @override
  _ProductGridListState createState() => _ProductGridListState();
}

class _ProductGridListState extends State<ProductGridList> {
  final BehaviorSubject<bool> hasItems = BehaviorSubject.seeded(false);
  List<Product> loadedProducts;

  @override
  void dispose() {
    hasItems.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build running');

    if (loadedProducts == null) {
      loadedProducts = [];
      widget.getProducts.then((products) {
        setState(() {
          loadedProducts.addAll(products);
        });
      });
    }

    if (loadedProducts == null || loadedProducts.isEmpty) {
      return Container();
    } else {
      return new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9),
            height: 56,
            child: Container(
              height: 50,
              padding: EdgeInsets.only(),
              child: Container(
                height: 56,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      padding: EdgeInsets.only(top: 7, left: 12, right: 12),
                      height: 38,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
            ),
          ),
          Container(
            height: 270,
            margin: EdgeInsets.only(),
            child: Container(
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: loadedProducts
                      .toList()
                      .map((p) => ProductGridItem(p))
                      .toList()),
            ),
          )
        ],
      );
    }
  }
}
