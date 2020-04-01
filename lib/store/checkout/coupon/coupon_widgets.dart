import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/checkout/checkout_bloc.dart';
import 'package:store/store/checkout/checkout_event_state.dart';
import 'package:store/store/checkout/coupon/coupon_repository.dart';

class CouponEntryWidget extends StatefulWidget {
  CouponEntryWidget();

  @override
  _CouponEntryWidgetState createState() => _CouponEntryWidgetState();
}

class _CouponEntryWidgetState extends State<CouponEntryWidget> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(),
          ),
          Container(
            child: RaisedButton(
              child: Text("ثبت"),
              onPressed: () {
                Provider.of<CheckoutBloc>(context)
                    .dispatch(AddCoupon(_codeController.text));
              },
            ),
          )
        ],
      ),
    );
  }
}

class CouponsListWidget extends StatefulWidget {
  final Function<Widget>(List<ValidCoupon> loadedCoupons) buildItems;

  const CouponsListWidget({Key key, this.buildItems}) : super(key: key);

  @override
  _CouponsListWidgetState createState() => _CouponsListWidgetState();
}

class _CouponsListWidgetState extends State<CouponsListWidget> {
  CheckoutBloc _checkoutBloc;

  @override
  Widget build(BuildContext context) {
    _checkoutBloc ??= Provider.of<CheckoutBloc>(context);

    return BlocBuilder<CheckoutBloc, CheckoutState>(
      bloc: _checkoutBloc,
      builder: (context, state) {
        if (state is CheckoutLoading) {
          return LoadingIndicator();
        } else if (state is OrderPayment) {
          return widget.buildItems(state.validCoupons);
        } else {
          return Container();
        }
      },
    );
  }
}
