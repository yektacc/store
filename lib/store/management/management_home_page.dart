import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/store/management/management_login_event_state.dart';
import 'package:store/store/management/manager_login_bloc.dart';
import 'package:store/store/management/seller/shop_management_page.dart';
import 'package:store/store/management/service/service_management_page.dart';

import 'manager_login_page.dart';
import 'model.dart';

class ManagementHomePage extends StatefulWidget {
  static const String routeName = 'sellerpage';

  ManagementHomePage();

  @override
  _ManagementHomePageState createState() => _ManagementHomePageState();
}

class _ManagementHomePageState extends State<ManagementHomePage> {
  ManagerLoginBloc _managerLoginBloc;
  StreamSubscription blocSub;

  @override
  Widget build(BuildContext context) {
    if (_managerLoginBloc == null) {
      _managerLoginBloc = Provider.of<ManagerLoginBloc>(context);
    }

    blocSub ??= _managerLoginBloc.state.listen((state) {
      if (state is SMWaitingForLogin) {
        Navigator.of(context).popAndPushNamed(ManagerLoginPage.routeName);
      }
    });

    return Container(
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: CustomAppBar(
            backgroundColor: AppColors.second_color,
            elevation: 0,
            title: Text(
              "مدیریت مراکز",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          body: BlocBuilder<ManagerLoginBloc, ManagerLoginState>(
            bloc: _managerLoginBloc,
            builder: (context, state) {
              if (state is ManagerLoggedIn) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8))),
                            padding:
                            EdgeInsets.only(right: 12, top: 10, bottom: 10),
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.store,
                                  color: Colors.grey[700],
                                  size: 18,
                                ),
                                Text(
                                  "  مراکز شما ",
                                  style: TextStyle(
                                      color: AppColors.second_color,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            /*   padding:
                                EdgeInsets.only(top: 16, bottom: 16, right: 10),*/
                            child: ListView(
//                              scrollDirection: Axis.horizontal,
                              children: state.user.centerIdentifiers
                                  .map((idf) => _buildCenterItem(idf))
                                  .toList(),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  child: Card(
                                    child: Padding(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'خروج از حساب',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          Padding(
                                            child: Icon(
                                              Icons.exit_to_app,
                                              color: Colors.red,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                          )
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 9),
                                    ),
                                  ),
                                  onTap: () {
                                    _managerLoginBloc.dispatch(LogoutManager());
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return LoadingIndicator();
              }
            },
          )),
    );
  }

  @override
  void dispose() {
    blocSub.cancel();
    super.dispose();
  }

  Widget _buildCenterItem(CenterIdentifier identifier) {
    var provinceRepo = Provider.of<ProvinceRepository>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          if (identifier is ShopIdentifier) {
            return ShopManagementPage(identifier);
          } else if (identifier is ServiceIdentifier) {
            return ServiceManagementPage(identifier);
          } else {
            throw ('error type not valid');
          }
        }));
      },
      child: Card(
        elevation: 6,
        child: Container(
            height: 100,
//            alignment: Alignment.centerRight,
//            width: 130,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      identifier.name.toString(),
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(4),
                          bottomLeft: Radius.circular(4))),
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        child: Icon(
                          Icons.location_on,
                          size: 18,
                          color: AppColors.second_color,
                        ),
                        padding: EdgeInsets.only(right: 6, left: 7),
                      ),
                      Container(
                        child: Text(
                          provinceRepo.getCityName(identifier.cityId),
                          style: TextStyle(color: AppColors.second_color),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
