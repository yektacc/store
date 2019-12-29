import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/products/product_pictures_repository.dart';
import 'package:store/store/products/cart/cart_bloc.dart';
import 'package:store/store/products/cart/cart_bloc_event.dart';
import 'package:store/store/products/detail/product_detail_page.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/products/product/product.dart';

class ProductListItem extends StatelessWidget {
  final Product _product;
  final int _initialCount;
  final bool _purchasable;

  ProductListItem(this._product, this._initialCount, {bool purchasable = true})
      : this._purchasable = purchasable;

/*  ProductListItem.fromExtended(ExtendedProduct extendedProduct, this._initialCount) {
    this._product = ExtendedProduct.ofProduct()
  };*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /* Navigator.of(context)
            .push(AppRoutes.productDetailPage(context, _exProduct));*/
        Navigator.pushNamed(
          context,
          ProductDetailPage.routeName,
          arguments: DetailPageArgs(_product.id, _product.storeThumbnail.id,
              _product.imgUrl, _product.brand),
        );
      },
      child: new Card(
        child: Container(
          height: 200,
          child: new Row(
            children: <Widget>[
              new Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: _product.imgUrl != null
                        ? Helpers.image(_product.imgUrl)
                        : FutureBuilder<List<ProductPicture>>(
                            future:
                                Provider.of<ProductPicturesRepository>(context)
                                    .fetch(int.parse(_product.id)),
                            builder: (context, snapshot) {
                              if (snapshot != null && snapshot.data != null &&
                                  snapshot.data.isNotEmpty) {
                                return Helpers.image(snapshot.data[0].imageURL);
                              } else {
                                return Container();
                              }
                            }),
                  ),
                ),
              ),
              new Expanded(
                flex: 2,
                child: new Column(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "${_product.name}",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        )),
                    Container(
                      height: 28,
                      alignment: Alignment.centerRight,
                      child: RatingBarIndicator(
                        rating: 2.75,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 18.0,
                        direction: Axis.horizontal,
                      ),
                    ),
                    Divider(),
                    Expanded(
                      flex: 1,
                      child: _product.price is PriceNotAvailable
                          ? Container()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(_product.price.formatted(),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.green)),
                              ),
                            ),
                    ),
                    _purchasable
                        ? BuyingCountWgt(
                            (CountWgtEvent e) {
                              if (e == CountWgtEvent.ADD) {
                                Provider.of<CartBloc>(context)
                                    .dispatch(Add(_product));
                              } else {
                                Provider.of<CartBloc>(context)
                                    .dispatch(Remove(_product));
                              }
                            },
                            initialCount: _initialCount,
                          )
                        : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum CountWgtEvent { ADD, REMOVE }

class BuyingCountWgt extends StatefulWidget {
  final Function(CountWgtEvent) _onCountChange;
  int initialCount;

  BuyingCountWgt(this._onCountChange, {this.initialCount = 0});

  @override
  _BuyingCountWgtState createState() => _BuyingCountWgtState();
}

class _BuyingCountWgtState extends State<BuyingCountWgt>
    with TickerProviderStateMixin {
  AnimationController plusAnimCtrl;
  Animation<Offset> plusOffset;

  final double size = 40;
  final double margin = 3;

  int count;

  AnimationController minusAnimCtrl;
  Animation<Offset> minusOffset;

  _updateCount(CountWgtEvent c) {
    if (c == CountWgtEvent.ADD) {
      count++;
    } else {
      count--;
    }
    widget._onCountChange(c);
  }

  @override
  void initState() {
    super.initState();

    // plus
    plusAnimCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));

    plusOffset = Tween<Offset>(begin: Offset(0, 0), end: Offset(1, 0))
        .animate(CurvedAnimation(
      parent: plusAnimCtrl,
      curve: Curves.fastOutSlowIn,
    ));

    // minus
    minusAnimCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));

    minusOffset = Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0))
        .animate(CurvedAnimation(
      parent: minusAnimCtrl,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    count = widget.initialCount;

    if (!plusAnimCtrl.isCompleted && !minusAnimCtrl.isCompleted && count > 0) {
      plusAnimCtrl.forward();
      minusAnimCtrl.forward().then((v) {
        setState(() {});
      });
    }

    if (plusAnimCtrl.isCompleted && minusAnimCtrl.isCompleted && count == 0) {
      plusAnimCtrl.reverse();
      minusAnimCtrl.reverse().then((v) {
        setState(() {});
      });
    }

    return Container(
      width: size * 5,
      height: size,
      margin: EdgeInsets.only(bottom: 6),
      child: Align(
          alignment: Alignment.centerLeft,
          child: new Container(
              width: size * 8,
              height: size,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    new SlideTransition(
                      position: plusOffset,
                      child: Container(
                        height: size,
                        width: size,
                        child: Container(
                          decoration: new BoxDecoration(
                            border: Border.all(color: AppColors.main_color),
                            shape: BoxShape.circle,
                          ),
                          margin: EdgeInsets.all(margin),
                          child: Icon(
                            Icons.exposure_plus_1,
                            size: 16,
                            color: AppColors.main_color,
                          ),
                        ),
                      ),
                    ),
                    new SlideTransition(
                      position: minusOffset,
                      child: Container(
                        height: size,
                        width: size,
                        child: Container(
                            decoration: new BoxDecoration(
                              border: Border.all(color: AppColors.main_color),
                              shape: BoxShape.circle,
                            ),
                            margin: EdgeInsets.all(margin),
                            child: Icon(
                              Icons.exposure_neg_1,
                              size: 16,
                              color: AppColors.main_color,
                            )),
                      ),
                    ),
                    new Container(
                      height: size,
                      width: size * 3,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: size - margin,
                            width: size - margin,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _updateCount(CountWgtEvent.ADD);
                                });
                              },
                            ),
                          ),
                          Container(
                              height: size,
                              width: size,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                              margin: EdgeInsets.all(margin),
                              child: GestureDetector(
                                onTap: () {
                                  plusAnimCtrl.forward();
                                  minusAnimCtrl.forward().then((v) {
                                    setState(() {
                                      _updateCount(CountWgtEvent.ADD);
                                    });
                                  });
                                },
                                child: count == 0
                                    ? Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.white,
                                        size: 19,
                                      )
                                    : Center(
                                        child: Text(
                                          count.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                              )),
                          Container(
                            height: size - margin,
                            width: size - margin,
                            child: GestureDetector(
                              onTap: () {
                                print(count);
                                if (count == 1) {
                                  plusAnimCtrl.reverse();
                                  minusAnimCtrl.reverse().then((v) {
                                    setState(() {
                                      _updateCount(CountWgtEvent.REMOVE);
                                    });
                                  });
                                } else {
                                  setState(() {
                                    _updateCount(CountWgtEvent.REMOVE);
                                  });
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}

class ProductCartListItem extends StatelessWidget {
  final Product _product;

  ProductCartListItem(this._product);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 7,
          child: new GestureDetector(
            onTap: () {
              /*Navigator.of(context)
                  .push(AppRoutes.productDetailPage(context, _product));*/
              Navigator.pushNamed(
                context,
                ProductDetailPage.routeName,
                arguments: DetailPageArgs(
                    _product.id,
                    _product.storeThumbnail.id,
                    _product.imgUrl,
                    _product.brand),
              );
            },
            child: new Card(
              child: Container(
                height: 140,
                width: 276,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: new Column(
                        children: <Widget>[
                          Expanded(
                              child: Center(
                            child: Container(
                              child: Text("${_product.name}"),
                            ),
                          )),
                          Divider(),
                          Expanded(
                            child: Center(
                              child: Container(
                                child: Text(_product.price.formatted()),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: _product.imgUrl != null
                            ? Helpers.image(_product.imgUrl)
                            : FutureBuilder<List<ProductPicture>>(
                                future: Provider.of<ProductPicturesRepository>(
                                        context)
                                    .fetch(int.parse(_product.id)),
                                builder: (context, snapshot) {
                                  if (snapshot != null &&
                                      snapshot.data != null) {
                                    return Helpers.image(
                                        snapshot.data[0].imageURL);
                                  } else {
                                    return Container();
                                  }
                                }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
