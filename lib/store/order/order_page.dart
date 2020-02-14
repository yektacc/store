import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('سفارش‌های شما')),
      body: OrdersListWidget(),
    );
  }
}

class OrdersListWidget extends StatefulWidget {
  @override
  _OrdersListWidgetState createState() => _OrdersListWidgetState();
}

class _OrdersListWidgetState extends State<OrdersListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: Provider.of<LoginStatusBloc>(context),
      builder: (context, LoginStatusState state) {
        if (state is IsLoggedIn) {
          return StreamBuilder<List<PaidOrder>>(
            stream: Provider.of<PreviousOrdersRepository>(context)
                .getPaidOrders(state.user.sessionId),
            builder: (context, snapshot) {
              if (snapshot != null && snapshot.data != null) {
                return ListView(
                    children: snapshot.data
                        .map((po) => _buildOrderItem(po))
                        .toList());
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildOrderItem(PaidOrder order) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[800],
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
                          color: AppColors.second_color,
                          size: 18,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 6),
                        child: Text(
                          order.shopName,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        order.city ?? '',
                        style: TextStyle(color: Colors.grey[300]),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    order.total.formatted(),
                    style: TextStyle(fontSize: 15, color: Colors.grey[100]),
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
                                      color: AppColors.second_color),
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
                                      color: AppColors.grey[800]),
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
                                  style: TextStyle(color: AppColors.grey[800]),
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
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Column(
                        children: order.products
                            .map(_buildOrderProductWidget)
                            .toList(),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      )

      /**/,
    );
  }

  Widget _buildOrderProductWidget(OrderProductInfo product) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
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
                  '2 عدد',
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
