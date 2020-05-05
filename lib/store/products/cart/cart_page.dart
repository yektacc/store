import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/data_layer/centers/centers_repository.dart';
import 'package:store/services/centers/model.dart';
import 'package:store/store/checkout/checkout_bloc.dart';
import 'package:store/store/checkout/checkout_event_state.dart';
import 'package:store/store/home/home_page.dart';
import 'package:store/store/location/address/address_page.dart';
import 'package:store/store/login_register/login/login_page.dart';
import 'package:store/store/petstore/pet_store.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/products/product/product_item_wgt.dart';

import 'cart_bloc.dart';
import 'cart_bloc_event.dart';
import 'model.dart';

class CartPage extends StatefulWidget {
  static const String routeName = 'cartpage';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final BehaviorSubject<bool> isShownSubject = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> loading = BehaviorSubject.seeded(false);

  CartBloc _cartBloc;
  CheckoutBloc _checkoutBloc;
  StreamSubscription _sub;
  StreamSubscription _addressPageLaunchSub;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_cartBloc == null) {
      _cartBloc = Provider.of<CartBloc>(context);
    }

    if (_checkoutBloc == null) {
      _checkoutBloc = Provider.of<CheckoutBloc>(context);
      _checkoutBloc.dispatch(CheckoutClear());
    }

    _sub ??= _checkoutBloc.state.listen((state) {
      print('new state $state');
      if (state is CheckoutNotLoggedIn) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()));
        _sub.cancel();
      }
    });

    _cartBloc.dispatch(FetchCart());

    return Scaffold(
        appBar: CustomAppBar(
          light: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Future.delayed(Duration.zero, () {
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              });
            },
          ),
          actions: <Widget>[
            BlocBuilder<CartBloc, CartState>(
              bloc: _cartBloc,
              builder: (context, state) {
                if (state is CartLoaded && state.cart.count > 0) {
                  return FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.delete_forever,
                            color: AppColors.main_color,
                          ),
                          Container(
                            padding: EdgeInsets.only(),
                            child: Text(
                              'حذف همه',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.main_color),
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        _cartBloc.dispatch(Clear());
                      });
                } else {
                  return Container();
                }
              },
            )
          ],
          titleText: 'سبد خرید',
        ),
        body: Stack(
          children: <Widget>[
            BlocBuilder(
                bloc: _cartBloc,
                builder: (context, CartState cartState) {
                  print('current cart state: ' + cartState.toString());

                  if (cartState is CartLoading) {
                    return Center(
                      child: LoadingIndicator(),
                    );
                  } else if (cartState is CartLoaded) {
                    Map<StoreThumbnail, List<CartProduct>> productsByStore =
                    HashMap();

                    cartState.cart.products.forEach((cp) {
                      StoreThumbnail store = cp.product.storeThumbnail;

                      if (productsByStore.containsKey(store)) {
                        productsByStore[store].add(cp);
                      } else {
                        productsByStore[store] = [cp];
                      }
                    });

                    return new Column(
                      children: <Widget>[
                        /* new Expanded(*/
                        Expanded(child: _buildShopsList(productsByStore)),
                        Container(
                            child: new Container(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                  onTap: () {
                                    Provider.of<CheckoutBloc>(context)
                                        .dispatch(SubmitCart(cartState.cart));

                                    _addressPageLaunchSub ??=
                                        _checkoutBloc.state.listen((
                                            checkoutState) {
                                          if (checkoutState is SimpleOrder) {
                                            Navigator.of(context)
                                                .pushNamed(
                                                AddressPage.routeName);
                                            _addressPageLaunchSub.cancel();
                                            _addressPageLaunchSub = null;
                                          }
                                        });

                                    /*if (!loading.value) {
                                  Provider.of<LoginStatusBloc>(context)
                                      .state
                                      .listen((loginState) async {
                                    if (loginState is IsLoggedIn) {
                                      loading.add(true);
                                      String orderCode =
                                          await Provider.of<CartRepository>(
                                                  context)
                                              .sendCart(
                                                  loginState.user.sessionId,
                                                  cartState.products,
                                                  cartState.total.toString());
                                      if (orderCode != null) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddressPage(
                                                        orderCode,
                                                        loginState
                                                            .user.sessionId)));
                                      } else {
                                        Helpers.showToast(
                                            ('خطا! مجددا تلاش کنید'));
                                      }
                                      loading.add(false);
                                    } else {
                                      Provider.of<LoginBloc>(context)
                                          .dispatch(Reset());
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    }
                                  });
                                }*/
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: TotalBar(
                                            isShownSubject,
/*
                                    ((state.total) * (9 / 100)).toInt(),
*/
                                            cartState.cart.total),
                                      ),
                                      GotoAddressBottomBar()
                                    ],
                                  )),
                            ))
                      ],
                    );
                  } else if (cartState is CartEmpty) {
                    return new Center(
                      child: Container(
                        height: 210,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 150,
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.grey[300],
                                size: 110,
                              ),
                            ),
                            Container(
                              height: 60,
                              child: Center(
                                child: Text(
                                  "سبد خرید خالی است!",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 40,
                      width: 40,
                    );
                  }
                }),
            StreamBuilder<bool>(
              stream: loading,
              builder: (context, loadingSnp) {
                if (loadingSnp != null &&
                    loadingSnp.data != null &&
                    loadingSnp.data == true) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    color: Colors.black38,
                    child: LoadingIndicator(),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ));
  }

  Widget _buildShopsList(Map<StoreThumbnail, List<CartProduct>> map) {
    List<Widget> list = [];

    map.forEach((store, products) {
      list.add(Container(
        child: Column(
            children: <Widget>[
              Container(
                height: 70,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        store.name,
                        style: TextStyle(fontSize: 15),
                      ),
                      Container(
                        child: new FutureBuilder<String>(
                            future: Provider.of<CentersRepository>(context)
                                .getCityNameByCenterId(
                                CenterFetchType.STORE,
                                int.parse(store.id)),
                            builder: (context, snapshot) {
                              if (snapshot != null &&
                                  snapshot.data != null &&
                                  snapshot.data != '') {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  margin: EdgeInsets.only(right: 20),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 12,
                                        right: 8,
                                        top: 5,
                                        bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Icon(
                                            Icons.location_on,
                                            size: 17,
                                            color: AppColors.main_color,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ] +
                products.map((cp) => CartListItem(cp)).toList() +
                [Divider()]),
      ));
    });

    return ListView(children: list);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    isShownSubject.close();
    loading.close();
    _sub.cancel();
    _addressPageLaunchSub.cancel();
    super.dispose();
  }
}

class TotalBar extends StatefulWidget {
  final BehaviorSubject<bool> isShown;

  final int products;

  TotalBar(this.isShown /*, this.tax*/, this.products);

  @override
  _TotalBarState createState() => _TotalBarState();
}

class _TotalBarState extends State<TotalBar> {
  bool isShown = false;

  @override
  Widget build(BuildContext context) {
    print('isshown: $isShown');
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 17),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(top: BorderSide(color: Colors.grey[300]))),
            height: 62,
            child: new Column(
              children: <Widget>[
                new Container(
                  height: 60,
                  child: Row(
                    children: <Widget>[
                      Text(
                        " مجموع :",
                        style: TextStyle(fontSize: 12),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "     " +
                                Price.parseFormatted(
                                    (widget.products /*+ widget.tax*/)),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CartListItem extends StatelessWidget {
  final CartProduct _cartProduct;

  CartListItem(this._cartProduct);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: Container(
        height: 200,
        width: 320,
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Helpers.image(_cartProduct.product.imgUrl),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "${_cartProduct.product.name}",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(),
                      child: Text(_cartProduct.product.price.formatted(),
                          style: TextStyle(fontSize: 14, color: Colors.green)),
                    ),
                  ),
                ),
                BuyingCountWgt(
                      (CountWgtEvent e) {
                    if (e == CountWgtEvent.ADD) {
                      Provider.of<CartBloc>(context)
                          .dispatch(Add(_cartProduct.product));
                    } else {
                      Provider.of<CartBloc>(context)
                          .dispatch(Remove(_cartProduct.product));
                    }
                  },
                  initialCount: _cartProduct.count,
                )
              ],
            ),
            Container(
              color: Colors.grey[100],
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 17),
                      alignment: Alignment.centerRight,
                      child: Text("مجموع این محصول:",
                          style:
                          TextStyle(fontSize: 12, color: Colors.black54)),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 150,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.only(left: 14),
                        child: Text(
                            (_cartProduct.product.price.amount *
                                _cartProduct.count)
                                .toString() +
                                " تومان ",
                            style:
                            TextStyle(fontSize: 12, color: Colors.black54)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GotoAddressBottomBar extends StatelessWidget {
  GotoAddressBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 75),
      height: 56,
      color: AppColors.main_color,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "انتخاب آدرس",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
