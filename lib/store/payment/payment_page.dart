import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/location/address/model.dart';
import 'package:store/store/payment/zarin_pal/client.dart';
import 'package:store/store/products/cart/cart_bloc.dart';
import 'package:store/store/products/cart/cart_bloc_event.dart';
import 'package:store/store/products/cart/cart_product.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  final Address selectedAddress;
  final Price innerCityDeliveryPrice;
  final String orderCode;
  final String sessionId;

  PaymentPage(this.selectedAddress, this.innerCityDeliveryPrice, this.orderCode,
      this.sessionId);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int getTotalWithTax() {
    return getTotalWithoutTax() + getTax();
  }

  int getTax() {
    return (getTotalWithoutTax() * (9 / 100)).toInt();
  }

  int getDelivery() {
    return widget.innerCityDeliveryPrice.amount;
  }

  int getProductsTotal() {
    return Provider.of<CartBloc>(context).getTotal();
  }

  int getTotalWithoutTax() {
    return widget.innerCityDeliveryPrice.amount +
        Provider.of<CartBloc>(context).getTotal();
  }

/*
  int getTotalAmount() {
    return Provider.of<CartBloc>(context).getTotal();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'پرداخت',
          style: TextStyle(fontSize: 16, color: AppColors.main_color),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: AppColors.main_color,
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Column(
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
                                    margin: EdgeInsets.only(top: 10, bottom: 8),
                                    padding: EdgeInsets.only(
                                        top: 7, left: 12, right: 9),
                                    height: 38,
                                    child: Text(
                                      "جزییات فاکتور",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15)))),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(left: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 7),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.red,
                                                      width: 1),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(8))),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    'کپن تخفیف',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        right: 8, left: 4),
                                                    child:
                                                    Icon(Icons.local_offer,
                                                      color: Colors.red,),
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
                            bloc: Provider.of<CartBloc>(context),
                            builder: (context, CartState state) {
                              if (state is CartLoading) {
                                return Center(
                                  child: LoadingIndicator(),
                                );
                              } else if (state is CartLoaded) {
                                return BillDetail(state.products
                                    .map((oldcp) => CartProductAlt.fromProduct(
                                    oldcp.product, oldcp.count))
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
                /* new Positioned(
                  bottom: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 200,
                      height: 26,
                      decoration: BoxDecoration(
                          color: AppColors.main_color,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(8))),
                      child: Align(
                        child: Text(
                          "     نوع پرداخت را انتخاب کنید     ",
                          style:
                              TextStyle(color: Colors.grey[200], fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                )*/
              ],
            ),
          ),
          _buildBottomBar()
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 210,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.grey[300]))),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.grey[50],
                      child: Column(
                        children: <Widget>[
                          _buildAdditionalPriceItem(
                              Price.parseFormatted(getProductsTotal()),
                              Icons.shopping_cart,
                              "مجموع قیمت محصولات:"),
                          _buildAdditionalPriceItem(
                              Price.parseFormatted(getDelivery()),
                              Icons.pages,
                              "بسته بندی و ارسال درون شهری:"),
                          _buildAdditionalPriceItem(
                              Price.parseFormatted(getTax()),
                              Icons.monetization_on,
                              'مالیات بر ارزش افزوده: '),
                          _buildAdditionalPriceItem('پس کرایه  ',
                              Icons.local_shipping, 'هزینه ارسال بین شهری:'),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  Price.parseFormatted(getTotalWithTax()),
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
/*
              Provider.of<OrderRepository>(context).saveFinal(sessionId, orderId)
*/

              ZarinPalClient()
                  .getPaymentURL(
                  ZPPaymentRequest((getTotalWithTax()).toString()))
                  .then((res) {
                if (res is ZPPaymentSuccessResponse) {
                  launch(res.getURL());
                  ZarinPalClient()
                      .verifyPayment(ZPVerifyRequest(
                      res.authority, getTotalWithTax().toString()))
                      .then((zpresponse) {
                    if (zpresponse is ZPVerifySuccessResponse) {} else {}
                  });
                } else {}
              });
            },
            child: PayBillBottomBar(getTotalWithTax().toString()),
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
              color: Colors.cyan[400],
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

/*class PaymentTypeSelection extends StatefulWidget {
  int selectedIndex = -1;

  @override
  _PaymentTypeSelectionState createState() => _PaymentTypeSelectionState();
}*/

/*
class _PaymentTypeSelectionState extends State<PaymentTypeSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: double.infinity,
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 7),
          ),
          PaymentTypeItem(Icons.payment, "اعتباری", () {
            widget.selectedIndex = 0;
            setState(() {});
          }, widget.selectedIndex == 0),
          PaymentTypeItem(Icons.attach_money, "نقدی", () {
            widget.selectedIndex = 1;
            setState(() {});
          }, widget.selectedIndex == 1),
          Padding(
            padding: EdgeInsets.only(left: 7),
          ),
        ],
      ),
    );
  }
}
*/

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
