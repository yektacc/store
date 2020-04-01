import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/data_layer/products/product_pictures_repository.dart';
import 'package:store/store/home/product_grid_list.dart';
import 'package:store/store/login_register/login/login_page.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/petstore/pet_store.dart';
import 'package:store/store/products/cart/cart_bloc.dart';
import 'package:store/store/products/cart/cart_bloc_event.dart';
import 'package:store/store/products/cart/cart_page.dart';
import 'package:store/store/products/comments/comments_page.dart';
import 'package:store/store/products/detail/product_detail_bloc.dart';
import 'package:store/store/products/detail/product_detail_bloc_event.dart';
import 'package:store/store/products/detail/product_detail_model.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';
import 'package:store/store/products/favorites/favorite_widget.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/products/product/products_repository.dart';

class DetailPageArgs {
  final String productId;
  final String initialSellerId;
  final String img;
  final String brand;

  DetailPageArgs(this.productId, this.initialSellerId, this.img, this.brand);
}

class ProductDetailPage extends StatefulWidget {
  static const routeName = '/detailpage';

  final String productId;
  final String initialSellerId;
  final String imgUrl;
  final String brand;

  const ProductDetailPage(
      {@required this.productId,
      @required this.initialSellerId,
      @required this.imgUrl,
      @required this.brand});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductDetailBloc _bloc;
  ProductDetailRepository _detailRepository;

  DetailedProduct _detailedProduct;
  DetailSeller _currentSeller;
  ProductVariant _currentVariant;
  String _imgUrl;

  final List<DetailSeller> allSellers = [];

  final BehaviorSubject<bool> loading = BehaviorSubject.seeded(false);

  _switchSeller(DetailSeller newSeller) {
    setState(() {
      _currentSeller = newSeller;
    });
    _flashPage();
  }

  DetailSeller _getCurrentSeller() {
    return allSellers.firstWhere((sp) => sp == _currentSeller);
  }

  Future<String> _getImgUrl() async {
    if (widget.imgUrl != null && widget.imgUrl != '') {
      return widget.imgUrl;
    } else {
      var img = await Provider.of<ProductPicturesRepository>(context)
          .fetch(int.parse(widget.productId));
      if (img.isNotEmpty) {
        return img[0].imageURL;
//        return widget.imgUrl;
      } else {
        return '';
      }
    }
//    return widget.imgUrl;
  }

  Product _getCurrentProduct() {
    return Product(
        widget.productId,
        _currentSeller.variantId,
        _detailedProduct.titleFa,
        StoreThumbnail(_currentSeller.shopId, _currentSeller.name),
        _detailedProduct.subCategory,
        price: _currentSeller.salePrice,
        brand: _detailedProduct.brand,
        imgUrl: widget.imgUrl ?? '');
  }

  _flashPage() {
    loading.add(true);
    loading.addStream(Observable.timer(false, Duration(milliseconds: 600)));
  }

  @override
  void dispose() {
    loading.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = Provider.of<ProductDetailBloc>(context);
      _bloc.dispatch(LoadProductDetail(widget.productId));
    }

    if (_detailRepository == null) {
      _detailRepository = Provider.of<ProductDetailRepository>(context);
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: CustomAppBar(
        titleText: "جزییات محصول",
        actions: <Widget>[
          Container(
            width: 70,
            child: BlocBuilder(
              bloc: Provider.of<CartBloc>(context),
              builder: (context, CartState state) {
                if (state is CartLoaded) {
                  return CartButton(state.cart.count);
                } else {
                  return CartButton(0);
                }
              },
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: loading,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot != null && snapshot.data != null) {
              if (snapshot.data) {
                return Center(
                  child: LoadingIndicator(),
                );
              } else {
                return new BlocBuilder(
                    bloc: _bloc,
                    builder: (context, ProductDetailState state) {
                      if (state is ProductDetailLoaded) {
                        if (_detailedProduct == null) {
                          _detailedProduct = state.detailedProduct;
                        }

                        if (_currentSeller == null) {
                          _detailedProduct.variants.forEach((variant) {
                            if (allSellers.isEmpty) {
                              allSellers.addAll(variant.sellers);
                            }

                            print('all sellers: ' +
                                allSellers
                                    .map((s) => s.shopId.toString())
                                    .toList()
                                    .toString() +
                                '\n initial seller Id: ${widget
                                    .initialSellerId}');

                            _currentSeller = allSellers[0];
                            allSellers.forEach((sp) {
                              if (sp.shopId == widget.initialSellerId) {
                                _currentSeller = allSellers.firstWhere((sp) =>
                                    sp.shopId == widget.initialSellerId);
                              }
                            });
                          });

                          if (allSellers.isEmpty) {
                            state.detailedProduct.variants.forEach((v) =>
                                v.sellers.forEach((s) => allSellers.add(s)));
                          }
                        }
                        return new Container(
                          child: new ListView(
                            children: <Widget>[
                              Card(
                                margin: EdgeInsets.only(bottom: 4),
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                elevation: 3,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 300,
                                      child: FutureBuilder<String>(
                                        future: _getImgUrl(),
                                        builder: (context, snapshot) {
                                          if (snapshot != null &&
                                              snapshot.data != null &&
                                              snapshot.data.isNotEmpty) {
                                            return Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              width: double.infinity,
                                              child: CachedNetworkImage(
                                                imageUrl: snapshot.data,
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            color: Colors.grey[50],
                                            padding: EdgeInsets.only(
                                                top: 16, bottom: 16, right: 15),
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              state.detailedProduct.titleFa,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        AddToFavorite(_detailedProduct),
                                      ],
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 8, right: 15),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text("برند محصول:"),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  _getCurrentProduct().brand),
                                            ),
                                          ),
                                          Container(
                                            width: 25,
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      padding: EdgeInsets.only(right: 15),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text("وزن محصول:"),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                state.detailedProduct.weight
                                                        .toString() +
                                                    " " +
                                                    state.detailedProduct.unit,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 25,
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 10, top: 5),
                                              padding: EdgeInsets.only(
                                                  right: 10, left: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.grey[200]),
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                height: 30,
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 5, left: 3),
                                                      child: Icon(
                                                        Icons.store,
                                                        size: 17,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    Text(
                                                      _currentSeller.name,
                                                      style: TextStyle(
                                                          color:
                                                          Colors.grey[700],
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 10, top: 5),
                                              padding: EdgeInsets.only(
                                                  right: 10, left: 10),
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                height: 30,
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 5, left: 3),
                                                      child: Icon(
                                                        Icons.location_on,
                                                        size: 17,
                                                        color: AppColors
                                                            .main_color,
                                                      ),
                                                    ),
                                                    Text(
                                                      _currentSeller.city,
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 11,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 20),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _currentSeller.salePrice
                                                  .formatted(),
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(4),
                                              bottomLeft:
                                              Radius.circular(4))),
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: _showSubmitScore,
                                                child: Container(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  margin: EdgeInsets.only(
                                                      left: 10),
                                                  child: RatingBarIndicator(
                                                    textDirection:
                                                    TextDirection.ltr,
                                                    unratedColor:
                                                    Colors.grey[400],
                                                    rating: 2.75,
                                                    itemBuilder:
                                                        (context, index) =>
                                                        Icon(
                                                          Icons.star,
                                                          color: AppColors
                                                              .main_color,
                                                        ),
                                                    itemCount: 5,
                                                    itemSize: 25.0,
                                                    direction:
                                                    Axis.horizontal,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(
                                            bottom: 10, right: 8),
                                      ),
                                    ),
                                    _buildAddToCartWidget(),
                                  ],
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 13),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      state.detailedProduct.description != null
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 13),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    state.detailedProduct
                                                        .description,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(4),
                                                bottomLeft:
                                                Radius.circular(4))),
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                alignment:
                                                Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                CommentsPage(
                                                                    _currentSeller
                                                                        .saleItemId)));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .main_color,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(20)),
                                                    margin: EdgeInsets.only(
                                                        left: 12),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                              vertical: 6,
                                                              horizontal:
                                                              15),
                                                          child: Text(
                                                            "نظرات کاربران",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 12,
                                                              top: 4),
                                                          child: Icon(
                                                            Icons
                                                                .insert_comment,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.only(
                                              bottom: 14, top: 14, right: 8),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              allSellers.length != 1
                                  ? Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              alignment: Alignment.centerRight,
                                              margin: EdgeInsets.only(
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 8),
                                              child: Text(
                                                "این محصول در فروشگاه های دیگر",
                                                style: TextStyle(),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 220,
                                          child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: allSellers
                                                  .map(_getSellerItem)
                                                  .toList()),
                                        )
                                      ],
                                    )
                                  : Container(),
                              new ProductGridList(
                                  'محصولات مشابه',
                                  Provider.of<ProductsRepository>(context)
                                      .load(_detailedProduct.subCategory)
                                      .first),
                            ],
                          ),
                        );
                      } else {
                        return Center(child: LoadingIndicator());
                      }
                    });
              }
            } else {
              return Container();
            }
          }),
    );
  }

  void _showSubmitScore() {
    var loginStatusBloc = Provider.of<LoginStatusBloc>(context);
    if (loginStatusBloc.currentState is IsLoggedIn) {
      showDialog(
          context: context,
          builder: (context) => _buildScoreSubmissionDialog((score) =>
              _detailRepository
                  .sendScore(
                      _currentSeller.saleItemId,
                      (loginStatusBloc.currentState as IsLoggedIn)
                          .user
                          .sessionId,
                      score)
                  .then((success) {
                if (success) {
                  Helpers.showToast('امتیاز شما ثبت گردید.');
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(
                      msg: "خطا در اتصال!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.grey[50],
                      fontSize: 13.0);
                }
              })));
    } else if (loginStatusBloc.currentState is NotLoggedIn) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  int _getCountInCart() {
    var cartBloc = Provider.of<CartBloc>(context);

    if (cartBloc.currentState is CartLoaded) {
      var cart = (cartBloc.currentState as CartLoaded).cart;
      var products = cart.products.map((cp) => cp.product);
      if (products.contains(_getCurrentProduct())) {
        return cart.products
            .firstWhere((cp) => cp.product == _getCurrentProduct())
            .count;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  Widget _buildAddToCartWidget() {
    var cartBloc = Provider.of<CartBloc>(context);

    return BlocBuilder<CartBloc, CartState>(
      bloc: cartBloc,
      builder: (context, state) {
        return Container(
          height: 76,
          padding: EdgeInsets.only(right: 8, bottom: 8, top: 8),
          child: Row(
            children: <Widget>[
              Card(
                elevation: 6,
                child: Container(
                  height: 56,
                  width: 60,
                  child: GestureDetector(
                    onTap: () {
                      cartBloc.dispatch(Add(_getCurrentProduct()));
                    },
                    child: _getCountInCart() == 0
                        ? Icon(
                      Icons.add_shopping_cart,
                      size: 32,
                      color: AppColors.main_color,
                    )
                        : Icon(
                      Icons.add,
                      size: 35,
                      color: AppColors.main_color,
                    ),
                  ),
                ),
              ),
              _getCountInCart() == 0
                  ? Container()
                  : Card(
                elevation: 2,
                child: Container(
                  width: 60,
                  height: 56,
                  child: GestureDetector(
                    onTap: () {
                      cartBloc.dispatch(Remove(_getCurrentProduct()));
                    },
                    child: Icon(
                      Icons.remove,
                      size: 35,
                      color: AppColors.main_color,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 50),
                      alignment: Alignment.centerLeft,
                      child: _getCountInCart() == 0
                          ? Container()
                          : Text(
                        _getCountInCart().toString() + " عدد ",
                        style: TextStyle(
                            fontSize: 22,
                            color: AppColors.second_color,
                            fontWeight: FontWeight.bold),
                      ))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreSubmissionDialog(Function(int score) onClick) {
    final double initialRate = 3;
    double currentRating = initialRate;

    return AlertDialog(
      title: Container(
        child: Text(
          'ثبت امتیاز',
          style: TextStyle(fontSize: 14),
        ),
      ),
      content: Container(
        alignment: Alignment.center,
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 30),
              child: RatingBar(
                textDirection: TextDirection.ltr,
                initialRating: initialRate,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 30,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  currentRating = rating;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Card(
                  color: Colors.green,
                  child: FlatButton(
                    child: Text(
                      'ثبت',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => onClick(currentRating.toInt()),
                  ),
                ),
                Card(
                  child: FlatButton(
                    child: Text('انصراف'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _getSellerItem(DetailSeller seller) {
    if (seller.shopId == _currentSeller.shopId) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          _switchSeller(seller);
        },
        child: new Card(
          child: Container(
            width: 145,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: FutureBuilder<String>(
                    future: _getImgUrl(),
                    builder: (context, snapshot) {
                      if (snapshot != null &&
                          snapshot.data != null &&
                          snapshot.data.isNotEmpty) {
                        return Container(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data,
                            ));
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                      height: 30,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(4),
                              bottomLeft: Radius.circular(4))),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 8),
                            height: 30,
                            alignment: Alignment.centerRight,
                            child: Text(
                              seller.salePrice.formatted(),
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 6,
                              color: AppColors.second_color,
                              margin: EdgeInsets.only(
                                  right: 8, left: 8, bottom: 8, top: 4),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          seller.name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 0.1,
                                      width: double.infinity,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 6),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(
                                                Icons.location_on,
                                                color: Colors.red[50],
                                                size: 16,
                                              ),
                                            ),
                                            Text(
                                              seller.city,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class CartButton extends StatelessWidget {
  final int cartCount;

  CartButton(this.cartCount);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: new IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).popAndPushNamed(CartPage.routeName);
              }),
        ),
        Expanded(
          child: Container(
            child: cartCount != 0 ? Text(cartCount.toString()) : Container(),
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
        )
      ],
    );
  }
}
