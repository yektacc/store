import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/products/product_pictures_repository.dart';
import 'package:store/store/products/detail/product_detail_page.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/products/product/product.dart';

class ProductGridItem extends StatelessWidget {
  final Product _product;

  ProductGridItem(this._product);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        /*Navigator.of(context)
            .push(AppRoutes.productDetailPage(context, _product));*/
        Navigator.pushNamed(
          context,
          ProductDetailPage.routeName,
          arguments: DetailPageArgs(_product.id, _product.storeThumbnail.id,
              _product.imgUrl, _product.brand),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: new Card(
          elevation: 3,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            width: 155,
            child: Column(
              children: <Widget>[
                Expanded(
                  child:
                      /* Hero(
            tag: 'imageHero',
            child: */
/*
                      Helpers.image(_product.imgUrl),
*/
/*          ),*/

                      _product.imgUrl != null
                          ? Helpers.image(_product.imgUrl)
                          : FutureBuilder<List<ProductPicture>>(
                              future: Provider.of<ProductPicturesRepository>(
                                      context)
                                  .fetch(int.parse(_product.id)),
                              builder: (context, snapshot) {
                                if (snapshot != null && snapshot.data != null &&
                                    snapshot.data.isNotEmpty) {
                                  return Helpers.image(
                                      snapshot.data[0].imageURL);
                                } else {
                                  return Container();
                                }
                              }),
                  flex: 3,
                ),
                Divider(),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 7),
                    child: Text(
                      _product.name,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  flex: 1,
                ),
                _product.price is PriceNotAvailable
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(right: 7),
                        height: 27,
                        alignment: Alignment.centerRight,
                        child: Text(
                          _product.price.formatted(),
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                _product.storeThumbnail.name == '' ? Container() : Container(
                  padding: EdgeInsets.only(right: 7),
                  height: 27,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4)),
                    color: Colors.grey[100],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            /*_product.storeThumbnail.name*/
                            _product.storeThumbnail.name,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      Container(
                        height: 27,
                        width: 27,
                        child: Icon(
                          Icons.store,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
