import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/common/widgets/form_fields.dart';
import 'package:store/store/checkout/checkout_bloc.dart';
import 'package:store/store/checkout/checkout_event_state.dart';
import 'package:store/store/checkout/coupon/coupon_repository.dart';
import 'package:store/store/home/home_page.dart';
import 'package:store/store/products/cart/cart_bloc.dart';
import 'package:store/store/products/cart/cart_bloc_event.dart';
import 'package:store/store/products/cart/model.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  static const String routeName = 'paymentpage';

  PaymentPage();

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  CheckoutBloc _checkoutBloc;
  StreamSubscription _linkingSub;
  StreamSubscription _successSub;
  StreamSubscription _launchSub;
  bool launched = false;
  final BehaviorSubject<bool> couponOverlayVisibility =
  BehaviorSubject.seeded(false);

  @override
  void dispose() {
    _linkingSub.cancel();
    _successSub.cancel();
    _launchSub.cancel();
    couponOverlayVisibility.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _linkingSub ??= getLinksStream().listen((String link) {
      if (link.contains('epet24://open-epet-app')) {
        _checkoutBloc.dispatch(VerifyPayment());
      }
    }, onError: (err) {
      print(err);
    });

    _checkoutBloc ??= Provider.of<CheckoutBloc>(context);

    _successSub ??= _checkoutBloc.state.listen((state) {
      if (state is PaymentSuccessful) {
        Helpers.showToast('خرید شما ثبت شد.');
        _checkoutBloc.dispatch(CheckoutClear());
        Navigator.of(context).popAndPushNamed(HomePage.routeName);
      }
    });

    return Stack(
      children: <Widget>[
        BlocBuilder(
          bloc: _checkoutBloc,
          builder: (context, state) {
//        if (state is CheckoutPayment) {
            return Scaffold(
                appBar: CustomAppBar(
                  titleText: 'فاکتور نهایی',
                  light: true,
                ),
                body: state is OrderPayment
                    ? Column(
                  children: <Widget>[
                    Expanded(
                      child: new Stack(
                        children: <Widget>[
                          new SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Container(
                              color: Colors.grey[200],
                              child: Column(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: 10, bottom: 8),
                                              padding: EdgeInsets.only(
                                                  top: 7,
                                                  left: 12,
                                                  right: 9),
                                              height: 38,
                                              child: Text(
                                                "جزییات فاکتور",
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      topLeft: Radius
                                                          .circular(
                                                          15),
                                                      bottomLeft: Radius
                                                          .circular(
                                                          15)))),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      couponOverlayVisibility
                                                          .add(true);
                                                    },
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        margin: EdgeInsets
                                                            .only(
                                                            left: 10),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            12,
                                                            vertical:
                                                            7),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .red,
                                                                width: 1),
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          children: <
                                                              Widget>[
                                                            Text(
                                                              'کپن تخفیف',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  right:
                                                                  8,
                                                                  left:
                                                                  4),
                                                              child: Icon(
                                                                Icons
                                                                    .local_offer,
                                                                color: Colors
                                                                    .red,
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                  Expanded(
                                    child: BlocBuilder(
                                      bloc:
                                      Provider.of<CartBloc>(context),
                                      builder:
                                          (context, CartState state) {
                                        if (state is CartLoading) {
                                          return Center(
                                            child: LoadingIndicator(),
                                          );
                                        } else if (state is CartLoaded) {
                                          return BillDetail(state
                                              .cart.products
                                              .map((oldcp) =>
                                              CartProductAlt
                                                  .fromProduct(
                                                  oldcp.product,
                                                  oldcp.count))
                                              .toList());
                                        } else {
                                          return Container(
                                            child: Text("error"),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildBottomBar(state)
                  ],
                )
                    : state is VerifyingPayment
                    ? Center(
                  child: Container(
                    child: Text('درحال بررسی وضعیت پرداخت'),
                  ),
                )
                    : LoadingIndicator());
          },
        ),
        StreamBuilder<bool>(
          stream: couponOverlayVisibility,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data) {
              return CouponOverlay(couponOverlayVisibility);
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }

  Widget _buildBottomBar(OrderPayment state) {
    return Container(
      height: 240,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[300]))),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.grey[50],
                      child: Column(
                        children: <Widget>[
                          _buildAdditionalPriceItem(
                              Price.parseFormatted(state.productsTotal),
                              Icons.shopping_cart,
                              "مجموع قیمت محصولات:"),
                          _buildAdditionalPriceItem(
                              Price.parseFormatted(state.deliveryPrice),
                              Icons.pages,
                              "بسته بندی و ارسال درون شهری:"),
                          _buildAdditionalPriceItem(
                              Price.parseFormatted(state.tax),
                              Icons.monetization_on,
                              'مالیات بر ارزش افزوده: '),
                          _buildAdditionalPriceItem('پس کرایه  ',
                              Icons.local_shipping, 'هزینه ارسال بین شهری:'),
                          _buildCouponPriceItem(
                              Price.parseFormatted(state.couponSum)),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  Price.parseFormatted(state.toPayAmount),
                                  style: TextStyle(
                                      color: Colors.grey[900], fontSize: 14),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              _checkoutBloc.dispatch(ReadyForGateway());

              _launchSub ??= _checkoutBloc.state.listen((state) {
                if (state is LaunchGateway) {
                  launch(state.url);
                  launched = true;
                }
              });
            },
            child: PayBillBottomBar(state.toPayAmount.toString()),
          )
        ],
      ),
    );
  }

  Widget _buildAdditionalPriceItem(String price, IconData icon, String title) {
    return Container(
      margin: EdgeInsets.only(right: 7, left: 6, top: 6),
      child: new Row(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 11)),
          Expanded(
            child: Container(
              width: 20,
              alignment: Alignment.centerLeft,
              child: Text(
                price,
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
          Container(
            width: 20,
            alignment: Alignment.centerLeft,
            child: Icon(
              icon,
              color: Colors.grey[400],
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponPriceItem(String price) {
    return Container(
      margin: EdgeInsets.only(right: 7, left: 6, top: 6),
      child: new Row(
        children: <Widget>[
          Text('مجموع کدهای تخفیف:', style: TextStyle(fontSize: 11)),
          Expanded(
            child: Container(
              width: 20,
              alignment: Alignment.centerLeft,
              child: Text(
                price,
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
          Container(
            width: 20,
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.local_offer,
              color: AppColors.main_color,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class BillDetail extends StatelessWidget {
  final List<CartProductAlt> _cartProducts;

  const BillDetail(this._cartProducts);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(children: <Widget>[
        _buildCartItemsList(_cartProducts),
        Padding(
          padding: EdgeInsets.only(bottom: 25),
        )
      ]),
    );
  }

  Column _buildCartItemsList(List<CartProductAlt> products) {
    return Column(
        children: List.generate(products.length, (index) {
          return _cartItem(products[index]);
        }));
  }

  Widget _cartItem(CartProductAlt cartProduct) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 3),
/*
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
*/
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Text(
              cartProduct.name,
              style: TextStyle(fontSize: 10),
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(cartProduct.count.toString()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.clear,
                              size: 14,
                            ),
                          ),
                          Text(cartProduct.price.formatted())
                        ]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                  child: Text(
                      (cartProduct.price.formattedCounted(cartProduct.count))
                          .toString()),
                )
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}

class PaymentTypeItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  PaymentTypeItem(this.icon, this.title, this.onTap, this.isSelected);

  @override
  _PaymentTypeItemState createState() => _PaymentTypeItemState();
}

class _PaymentTypeItemState extends State<PaymentTypeItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        child: new Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          color: Colors.white,
          child: Container(
            decoration: widget.isSelected
                ? BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: AppColors.main_color))
                : null,
            child: new Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.grey[200],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 11,
                            color: widget.isSelected
                                ? AppColors.main_color
                                : Colors.black87),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: Icon(
                        widget.icon,
                        color: widget.isSelected
                            ? AppColors.main_color
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PayBillBottomBar extends StatelessWidget {
  final String total;

  PayBillBottomBar(this.total);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppColors.main_color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
          ),
          new Container(
            child: Text(
              "پرداخت آنلاین ",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class CouponOverlay extends StatefulWidget {
  final BehaviorSubject<bool> ownVisibility;

  CouponOverlay(this.ownVisibility);

  @override
  _CouponOverlayState createState() => _CouponOverlayState();
}

class _CouponOverlayState extends State<CouponOverlay> {
  final TextEditingController codeController = TextEditingController();
  CheckoutBloc _checkoutBloc;

  final double topPadding = 4;
  final double bottomPadding = 20;
  final double topBarHeight = 45;
  final double mainAreaHeight = 80;
  final double addedCouponHeight = 56;

  @override
  Widget build(BuildContext context) {
    _checkoutBloc ??= Provider.of<CheckoutBloc>(context);

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromARGB(150, 0, 0, 0),
      child: BlocBuilder<CheckoutBloc, CheckoutState>(
        bloc: _checkoutBloc,
        builder: (context, state) {
          int couponsCount = 0;
          if (state is OrderPayment && state.validCoupons.isNotEmpty) {
            couponsCount = state.validCoupons.length;
          }

          var cHeight = topPadding +
              bottomPadding +
              topBarHeight +
              mainAreaHeight +
              couponsCount * addedCouponHeight;

          return SingleChildScrollView(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 100, horizontal: 10),
              child: AnimatedContainer(
                height: cHeight,
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                padding:
                EdgeInsets.only(bottom: bottomPadding, top: topPadding),
                child: Column(children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    height: topBarHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          topLeft: Radius.circular(4)),
                    ),
                    child: Container(
                      height: topBarHeight,
                      child: IconButton(
                        onPressed: () {
                          widget.ownVisibility.add(false);
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                  Container(
                    height: mainAreaHeight,
                    alignment: Alignment.center,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 6),
                            child: FormFields.outlinedTextWithIcon(
                                codeController, Icons.local_offer, 'کد تخفیف'),
                          ),
                        ),
                        state is OrderPayment
                            ? FlatButton(
                          onPressed: () {
                            _checkoutBloc
                                .dispatch(AddCoupon(codeController.text));
                          },
                          child: Container(
                            child: Text(
                              'اعمال کد',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        )
                            : state is CheckoutLoading
                            ? Padding(
                          padding: EdgeInsets.only(left: 11),
                          child: CircularProgressIndicator(),
                        )
                            : Container()
                      ],
                    ),
                  ),
                  state is OrderPayment
                      ? Column(
                    children:
                    state.validCoupons.map(_buildCouponItem).toList(),
                  )
                      : Container()
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCouponItem(ValidCoupon coupon) {
    return Container(
      color: Colors.red[50],
      height: 56,
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(
              Icons.star,
              color: Colors.white,
              size: 21,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(coupon.code),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(coupon.discount.formatted()),
            ),
          )
        ],
      ),
    );
  }
}
