import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/products/detail/product_detail_page.dart';
import 'package:store/store/products/product/product.dart';

class SearchResultWgt extends StatelessWidget {
  final List<Product> _products;

  SearchResultWgt(this._products);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _products
          .map((p) => GestureDetector(
                onTap: () {
                  /*Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(ExtendedProduct([p], p.id))));*/
                  Navigator.of(context).pushNamed(ProductDetailPage.routeName,
                      arguments: DetailPageArgs(p.id, p.storeThumbnail.id,p.imgUrl,p.brand));
                },
                child: Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                             Padding(padding: EdgeInsets.only(top: 6),child:  Text(
                               p.name,
                               style: TextStyle(fontSize: 12),
                             ),),
                              Padding(padding: EdgeInsets.only(top: 6,bottom: 8,right: 10),child:  Text(
                                p.price.formatted(),
                                style: TextStyle(fontSize: 12,color: Colors.green),
                              ),),
                            ],
                          ),
                        ),
                        Container(
                          height: 70,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Helpers.image(p.imgUrl),
                        )
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
