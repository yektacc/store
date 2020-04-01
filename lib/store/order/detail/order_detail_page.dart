import 'package:flutter/material.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';

class OrderDetailPage extends StatefulWidget {
  final List<PaidOrder> orders;
  final PaidOrder initialOrder;

  OrderDetailPage(this.orders, this.initialOrder);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.orders.length,
      initialIndex: widget.orders.indexOf(widget.initialOrder),
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
