import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/common/widgets/buttons.dart';
import 'package:store/common/widgets/form_fields.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/management/manager_login_bloc.dart';
import 'package:store/store/management/model.dart';
import 'package:store/store/order/order_bloc.dart';
import 'package:store/store/order/order_bloc_event_state.dart';

import 'order_product/order_product_bloc.dart';
import 'order_product/order_product_bloc_event_state.dart';

class UserOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'سفارش‌های شما',
        light: true,
      ),
      body: UserOrdersWidget(),
    );
  }
}

class ShopOrderPage extends StatelessWidget {
  final ShopIdentifier identifier;

  ShopOrderPage(this.identifier);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'سفارش‌های شما',
        light: true,
        altMainColor: true,
      ),
      body: ShopOrdersWidget(identifier),
    );
  }
}

class ShopOrdersWidget extends StatefulWidget {
  final ShopIdentifier identifier;

  ShopOrdersWidget(this.identifier);

  @override
  _ShopOrdersWidgetState createState() => _ShopOrdersWidgetState();
}

class _ShopOrdersWidgetState extends State<ShopOrdersWidget> {
  OrderBloc _orderBloc;

  @override
  Widget build(BuildContext context) {
    if (_orderBloc == null) {
      _orderBloc = OrderBloc(
          Provider.of<OrdersRepository>(context),
          Provider.of<LoginStatusBloc>(context),
          Provider.of<ManagerLoginBloc>(context));

      _orderBloc.dispatch(GetShopOrders(widget.identifier.id));
    }

    return BlocBuilder(
      bloc: Provider.of<LoginStatusBloc>(context),
      builder: (context, LoginStatusState state) {
        return BlocBuilder<OrderBloc, OrderState>(
          bloc: _orderBloc,
          builder: (context, state) {
            print('thestate:' + state.toString());
            if (state is OrdersLoaded) {
              return OrdersVListWidget(state.orders, _orderBloc);
            } else {
              return LoadingIndicator(
                color: Colors.blueGrey,
              );
            }
          },
        );
      },
    );
  }
}

class ShopOrdersBriefHWidget extends StatefulWidget {
  final ShopIdentifier identifier;

  ShopOrdersBriefHWidget(this.identifier);

  @override
  _ShopOrdersBriefHWidgetState createState() => _ShopOrdersBriefHWidgetState();
}

class _ShopOrdersBriefHWidgetState extends State<ShopOrdersBriefHWidget> {
  OrderBloc _orderBloc;

  @override
  Widget build(BuildContext context) {
    if (_orderBloc == null) {
      _orderBloc = OrderBloc(
          Provider.of<OrdersRepository>(context),
          Provider.of<LoginStatusBloc>(context),
          Provider.of<ManagerLoginBloc>(context));

      _orderBloc.dispatch(GetShopOrders(widget.identifier.id));
    }

    return BlocBuilder(
      bloc: Provider.of<LoginStatusBloc>(context),
      builder: (context, LoginStatusState state) {
        return BlocBuilder<OrderBloc, OrderState>(
          bloc: _orderBloc,
          builder: (context, state) {
            print('thestate:' + state.toString());
            if (state is OrdersLoaded) {
              return OrdersHListWidget(state.orders);
            } else {
              return LoadingIndicator();
            }
          },
        );
      },
    );
  }
}

class UserOrdersWidget extends StatefulWidget {
  UserOrdersWidget();

  @override
  _UserOrdersWidgetState createState() => _UserOrdersWidgetState();
}

class _UserOrdersWidgetState extends State<UserOrdersWidget> {
  OrderBloc _orderBloc;

  @override
  Widget build(BuildContext context) {
    if (_orderBloc == null) {
      _orderBloc = OrderBloc(
          Provider.of<OrdersRepository>(context),
          Provider.of<LoginStatusBloc>(context),
          Provider.of<ManagerLoginBloc>(context));
      _orderBloc.dispatch(GetUserOrders());
    }

    return BlocBuilder(
      bloc: Provider.of<LoginStatusBloc>(context),
      builder: (context, LoginStatusState state) {
        return BlocBuilder<OrderBloc, OrderState>(
          bloc: _orderBloc,
          builder: (context, state) {
            print('thestate:' + state.toString());
            if (state is OrdersLoaded) {
              return OrdersVListWidget(state.orders, _orderBloc);
            } else {
              return LoadingIndicator();
            }
          },
        );
      },
    );
  }
}

class OrdersVListWidget extends StatefulWidget {
  final List<PaidOrder> orders;
  final bool altColor;
  final OrderBloc orderBloc;

  OrdersVListWidget(this.orders, this.orderBloc, {this.altColor = false});

  @override
  _OrdersVListWidgetState createState() => _OrdersVListWidgetState();
}

class _OrdersVListWidgetState extends State<OrdersVListWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.orders.isEmpty) {
      return Center(
        child: Text('سفارشی موجود نیست'),
      );
    } else {
      return ListView(
          children: widget.orders.map((po) => _buildOrderItem(po)).toList());
    }
  }

  bool isPacked(PaidOrder order) {
    return order is ShopPaidOrder &&
        order.sentInfo != null &&
        order.sentInfo.sent;
  }

  Widget _buildOrderItem(PaidOrder order) {
    return Card(
        color: isPacked(order) ? Colors.green[100] : null,
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: isPacked(order)
                      ? Colors.green[100]
                      : order is UserPaidOrder
                      ? AppColors.main_color
                      : AppColors.second_color,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4))),
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.store,
                            color:
                            isPacked(order) ? Colors.black : Colors.white,
                            size: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 6),
                          child: Text(
                            order.shopName,
                            style: TextStyle(
                                color: isPacked(order)
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
//                        Text(
//                          order.city ?? '',
//                          style: TextStyle(color: isPacked(order) ? Colors.black : Colors.grey[300]),
//                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      order.total.formatted(),
                      style: TextStyle(
                          fontSize: 15,
                          color: isPacked(order)
                              ? Colors.black
                              : Colors.grey[100]),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Row(
                            children: <Widget>[
                              Text('کد سفارش:'),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    order.orderCode,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600]),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Row(
                            children: <Widget>[
                              Text('تاریخ سفارش:'),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Helpers.getPersianDate(
                                        order.orderDate.split(' ')[0]),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.grey),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    order.address,
                                    style: TextStyle(color: AppColors.grey),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.grey[100],
                    title: Container(
                      child: Text(
                        'مشاهده محصولات',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Column(
                          children: order.products
                              .map(
                                (p) =>
                                _buildOrderProductWidget(
                                    p, order is ShopPaidOrder),
                          )
                              .toList(),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            order is ShopPaidOrder
                ? Container(
              alignment: Alignment.centerRight,
              height: 60,
              decoration: BoxDecoration(
                  color: isPacked(order)
                      ? Colors.green[100]
                      : Colors.grey[100],
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(4))),
              child: isPacked(order)
                  ? Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.done_outline),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 6),
                    child: Text(
                        'ارسال شده در تاریخ:   ${Helpers.getPersianDate(
                            order.sentInfo.sentDate)}'),
                  )
                ],
              )
                  : Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _orderSentButtonPressed(order),
                    child: Card(
                      margin: EdgeInsets.only(right: 12),
                      elevation: 7,
                      color: Colors.grey[50],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 11, vertical: 7),
                            child: Text(
                              'ثبت ارسال',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.local_shipping,
                              color: Colors.greenAccent[200],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
                : Container()
          ],
        ));
  }

  _orderSentButtonPressed(ShopPaidOrder order) {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Color.fromARGB(230, 255, 255, 255),
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            height: Helpers.getBodyHeight(context),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 170,
                    child: FormFields.big(
                      'پیام نهایی',
                      controller,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 50),
                    child: Buttons.simple('تایید', () {
                      widget.orderBloc.dispatch(OrderPacked(controller.text,
                          order.orderId, order.products[0].sellerId));
                      Navigator.of(context).pop();
                    }),
                  )
                ],
              ),
            ),
          );
        });
  }

  _returnButtonPressed(Function(String) submitPressed) {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Color.fromARGB(230, 255, 255, 255),
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            height: Helpers.getBodyHeight(context),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 170,
                    child: FormFields.big(
                      'پیام نهایی',
                      controller,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 50),
                    child: Buttons.simple('تایید', () {
                      submitPressed(controller.text);
                      Navigator.pop(context);
                    }),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildProductPackingIcon(bool isPacked, Function() onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.check_circle_outline),
      color: isPacked ? Colors.green : Colors.grey[700],
    );
  }

  Widget _buildReturnButton(Function(String) onPressed) {
    return Padding(
      padding: EdgeInsets.only(left: 7, right: 2),
      child: Buttons.small('ثبت مرجوعی', () => _returnButtonPressed(onPressed)),
    );
  }

  Widget _buildOrderProductWidget(OrderProductInfo product, bool shop) {
    var _orderProductBloc =
    PackingBloc(Provider.of<OrdersRepository>(context), product);
    _orderProductBloc.dispatch(GetPackingInfo());

    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              shop
                  ? BlocBuilder<PackingBloc, OrderProductState>(
                bloc: _orderProductBloc,
                builder: (context, state) {
                  if (state is IsPacked) {
                    return _buildProductPackingIcon(true, () {});
                  } else if (state is NotPacked) {
                    return _buildProductPackingIcon(false, () {
                      _orderProductBloc.dispatch(ProductPacked());
                    });
                  } else if (state is OrderProductLoading) {
                    return SmallLoadingIndicator();
                  } else {
                    return Container();
                  }
                },
              )
                  : _buildReturnButton((comment) {
                widget.orderBloc
                    .dispatch(SubmitProductReturn(product, comment));
              }),
              Expanded(
                child: Text(product.name),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Text(
                  product.quantity.toString() + " عدد ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.second_color),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class OrdersHListWidget extends StatefulWidget {
  final List<PaidOrder> orders;

  OrdersHListWidget(this.orders);

  @override
  _OrdersHListWidgetState createState() => _OrdersHListWidgetState();
}

class _OrdersHListWidgetState extends State<OrdersHListWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.orders.isEmpty) {
      return Center(
        child: Text('سفارشی موجود نیست'),
      );
    } else {
      return ListView(
          scrollDirection: Axis.horizontal,
          children: widget.orders.map((po) => _buildOrderItem(po)).toList());
    }
  }

  Widget _buildOrderItem(PaidOrder order) {
    return Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
          width: 160,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'کد سفارش:',
                                textAlign: TextAlign.right,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                order.orderCode,
                                style: TextStyle(
                                    color: AppColors.second_color,
                                    fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: AppColors.second_color,
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                Helpers.getPersianDate(
                                    order.orderDate.split(' ')[0]),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.grey[300],
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                order.city,
                                style: TextStyle(color: AppColors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(4))),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      /*child: Text(
                        order.total.formatted(),
                        style: TextStyle(
                            fontSize: 15, color: AppColors.second_color),
                      )*/
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
