import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/store/management/management_login_bloc.dart';
import 'package:store/store/management/management_login_event_state.dart';
import 'package:store/store/management/seller/shop_management_page.dart';
import 'package:store/store/management/service/service_management_page.dart';

import 'model.dart';

class ManagementHomePage extends StatefulWidget {
  static const String routeName = 'sellerpage';

  ManagementHomePage();

  @override
  _ManagementHomePageState createState() => _ManagementHomePageState();
}

class _ManagementHomePageState extends State<ManagementHomePage> {
  ManagerLoginBloc _managerLoginBloc;

  @override
  Widget build(BuildContext context) {
    if (_managerLoginBloc != null) {
      _managerLoginBloc = Provider.of<ManagerLoginBloc>(context);
    }

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

/*  _showShopSelection(BuildContext context, List<ShopIdentifier> shops,
      Function(ShopIdentifier) onShopTapped) {
    showDialog(
      context: context,
      builder: (context) {
        var provinceRepo = Provider.of<ProvinceRepository>(context);

        return new AlertDialog(
          titlePadding: EdgeInsets.only(),
          title: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 65,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Text(
                  'فروشگاه مورد نظر را انتخاب کنید',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              new Container(
                width: double.infinity,
                child: Column(
                  children: shops
                      .map((shop) => Container(
                            height: 60,
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: ListTile(
                                title: FlatButton(
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(shop.name),
                                        Expanded(
                                            child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(provinceRepo
                                              .getCityName(shop.cityId)),
                                        ))
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onShopTapped(shop);
                                  },
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }*/
}

//Widget _buildOrderListItem(ShopOrder order) {
//  return Column(
//    children: <Widget>[
//      Container(
//        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//        child: Container(
//          child: Column(
//            children: <Widget>[
//              Container(
//                height: 40,
//                alignment: Alignment.centerRight,
//                child: Text(order.quantity.toString()),
//              ),
//              Row(
//                children: <Widget>[
//                  Expanded(
//                    child: Text('سفارش'),
//                  )
//                ],
//              )
//            ],
//          ),
//        ),
//      ),
//      Divider()
//    ],
//  );
//}
