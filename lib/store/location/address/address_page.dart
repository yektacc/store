import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/store/checkout/checkout_bloc.dart';
import 'package:store/store/checkout/checkout_event_state.dart';
import 'package:store/store/checkout/delivery/delivery_page.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';

import 'address_bloc.dart';
import 'address_bloc_event.dart';
import 'address_list.dart';
import 'edit_address_page.dart';

class AddressPage extends StatefulWidget {
  static const String routeName = 'addresspage';

  AddressPage();

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  AddressBloc _addressBloc;
  String sessionId;
  AddressSelection _addressSelectionWgt;
  LoginStatusBloc _loginStatusBloc;
  CheckoutBloc _checkoutBloc;
  StreamSubscription _sub;
  StreamSubscription _launchDeliverySub;

  final BehaviorSubject loading = BehaviorSubject.seeded(false);

  @override
  void dispose() {
    loading.close();
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _addressBloc ??= Provider.of<AddressBloc>(context);

    _loginStatusBloc ??= Provider.of<LoginStatusBloc>(context);

    _checkoutBloc ??= Provider.of<CheckoutBloc>(context);

    _loginStatusBloc.state.listen((state) {
      if (state is IsLoggedIn) {
        _addressBloc.dispatch(
            FetchAddresses(int.parse(state.user.sessionId), forceUpdate: true));
        sessionId = state.user.sessionId;
      }
    });

    return Scaffold(
        appBar: CustomAppBar(
          light: true,
          elevation: 0,
          titleText: 'انتخاب آدرس',
        ),
        body: BlocBuilder<CheckoutBloc, CheckoutState>(
          bloc: _checkoutBloc,
          builder: (context, checkoutState) {
            if (checkoutState is SimpleOrder) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      new Container(
                        height: 70,
                        color: Colors.grey[200],
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                                padding: EdgeInsets.only(
                                    top: 7, left: 12, right: 12),
                                height: 38,
                                child: Text(
                                  "آدرس ها شما",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15))))),
                      ),
                      new Expanded(
                        child: Container(
                          color: Colors.grey[100],
                          child: new BlocBuilder(
                            bloc: _addressBloc,
                            builder: (context, AddressState state) {
                              if (state is AddressesLoaded) {
                                _addressSelectionWgt =
                                    AddressSelection(state.addresses);

                                loading.add(false);
                                return _addressSelectionWgt;
                              } else if (state is AddressesLoading) {
                                loading.add(true);
                                return Container();
                              } else {
                                return Container(
                                  child: Text('خطا!'),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      BlocBuilder(
                        bloc: _loginStatusBloc,
                        builder: (context, LoginStatusState state) {
                          if (state is IsLoggedIn) {
                            return new GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        AddressAddEditPage(
                                          false,
                                          sessionId:
                                          int.parse(state.user.sessionId),
                                        )));
                              },
                              child: new Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                ),
                                margin: EdgeInsets.only(),
                                height: 60,
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.add_location,
                                          color: AppColors.main_color,
                                          size: 25,
                                        ),
                                        margin: EdgeInsets.only(left: 3),
                                      ),
                                      Container(
                                        child: Text(
                                          "آدرس جدید",
                                          style: TextStyle(
                                              color: AppColors.main_color,
                                              fontSize: 14),
                                        ),
                                        margin: EdgeInsets.only(right: 3),

                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      new GestureDetector(
                        onTap: () {
                          if (_addressSelectionWgt != null &&
                              _addressSelectionWgt.selected != null) {
                            _checkoutBloc.dispatch(
                                SubmitAddress(_addressSelectionWgt.selected));
                            _sub ??= _checkoutBloc.state.listen((state) {
                              if (state is OrderWithDeliveryInf) {
                                Navigator.of(context)
                                    .pushNamed(DeliveryPage.routeName);
                              }
                            });
                          } else {
                            Helpers.showToast(
                                'لطفا آدرس مورد نظر را انتخاب کنید');
                          }
                        },
                        child: Hero(
                            tag: "bottom_bar",
                            child: GotoDeliveryBottomBar(
                              /*
                                _addressSelectionWgt != null &&
                                        _addressSelectionWgt.selected != null
                                    ? true
                                    : false*/
                            )),
                      )
                    ],
                  ),
                  StreamBuilder(
                    stream: loading,
                    builder: (context, loadingSnp) {
                      if (loadingSnp != null &&
                          loadingSnp.data != null &&
                          loadingSnp.data) {
                        return Container(
                          color: Colors.black12,
                          child: LoadingIndicator(),
                          alignment: Alignment.center,
                          height: double.infinity,
                          width: double.infinity,
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              );
            } else {
              return Container();
            }
          },
        ));
  }
}

class GotoDeliveryBottomBar extends StatelessWidget {
//  final bool enabled;

  GotoDeliveryBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppColors.main_color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 3),
            alignment: Alignment.centerLeft,
            child: Icon(Icons.local_shipping, color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.only(right: 3),
            alignment: Alignment.centerRight,
            child: Text(
              "نحوه ارسال",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          )
          /* Container()

          Expanded(
            flex: 4,
            child: ,
          ),
          Expanded(
            flex: 7,
            child: ,
          ),*/
        ],
      ),
    );
  }
}
