import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/products/product/product_grid_item.dart';
import 'package:rxdart/rxdart.dart';

class ProductGridList extends StatefulWidget {
  final String title;
  final Future<List<Product>> getProducts;

  ProductGridList(this.title, this.getProducts);

  @override
  _ProductGridListState createState() => _ProductGridListState();
}

class _ProductGridListState extends State<ProductGridList> {
  final BehaviorSubject<bool> hasItems = BehaviorSubject.seeded(true);

  @override
  void dispose() {
    hasItems.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
     StreamBuilder<bool>(
      stream: hasItems,
      builder: (context, snapshot) {
return         Container(
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
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
                color: AppColors.grey[200],
                borderRadius:
                BorderRadius.all(Radius.circular(10)))),
      ),
    ),
  ),
);
      },
    ),
        Container(
          height: 270,
          margin: EdgeInsets.only(),
          child: FutureBuilder(
            future: widget.getProducts,
            builder: (context, AsyncSnapshot<List<Product>> snapshot) {
              if (snapshot == null) {
                return LoadingIndicator();
              } else if (snapshot.data != null &&
                  snapshot.data.isNotEmpty) {
                return Container(
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data
                          .toList()
                          .map((p) => ProductGridItem(p))
                          .toList()),
                );
              } else {
                return Text("");
              }
            },
          ),
        )
      ],
    );
  }
}
