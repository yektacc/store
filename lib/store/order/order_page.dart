import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/data_layer/order/paid_orders_repository.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder(
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
      ),
    );
  }

  Widget _buildOrderItem(PaidOrder order) {
    return Text('a');
  }
}
