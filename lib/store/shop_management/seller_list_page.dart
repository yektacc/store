import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/data_layer/shop_management/shop_repository.dart';
import 'package:store/store/home/category_page.dart';
import 'package:store/store/order/order_page.dart';
import 'package:store/store/shop_management/seller_add_product_page.dart';
import 'package:store/store/shop_management/seller_detail_page.dart';
import 'package:store/store/shop_management/shop_management_bloc.dart';
import 'package:store/store/shop_management/shop_management_event_state.dart';
import 'package:store/store/structure/model.dart';
import 'package:store/store/structure/repository.dart';

import 'create_product_page.dart';

class SellersListPage extends StatefulWidget {
  static const String routeName = 'sellerpage';

/*
  final List<ShopIdentifier> _sellers = [];
*/

  SellersListPage(/*this.sellers*/);

  @override
  _SellersListPageState createState() => _SellersListPageState();
}

class _SellersListPageState extends State<SellersListPage> {
  ShopManagementBloc _shopBloc;

  @override
  Widget build(BuildContext context) {
    if (_shopBloc != null) {
      _shopBloc = Provider.of<ShopManagementBloc>(context);
    }

    return Container(
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.grey[800],
            elevation: 0,
            title: Text(
              "فروشگاه ها",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          body: BlocBuilder<ShopManagementBloc, ShopManagementState>(
            bloc: _shopBloc,
            builder: (context, state) {
              if (state is SMDataLoaded) {
                return Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      height: 84,
                      color: Colors.grey[800],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              elevation: 5,
                              color: Colors.grey[50],
                              margin: EdgeInsets.only(right: 10, left: 6),
                              child: new FlatButton(
                                onPressed: () {
                                  _showShopSelection(
                                      context,
                                      state.shops
                                          .map((s) => s.identifier)
                                          .toList(), (shop) {
                                    Navigator.of(context).pushNamed(
                                        CreateProductPage.routeName,
                                        arguments: shop);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                  ),
                                  alignment: Alignment.center,
                                  height: double.infinity,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8),
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'اضافه کردن محصول',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.add_box,
                                            color: AppColors.second_color,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new Expanded(
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              color: Colors.grey[50],
                              margin: EdgeInsets.only(left: 10, right: 6),
                              child: FlatButton(
                                onPressed: () {
                                  Provider.of<StructureRepository>(context)
                                      .fetch()
                                      .listen((pets) {
                                    _showShopSelection(
                                        context,
                                        state.shops
                                            .map((s) => s.identifier)
                                            .toList(), (shop) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryPage(
                                                      AllPets(pets),
                                                          () =>
                                                          Navigator.of(context)
                                                              .popAndPushNamed(
                                                              SellerAddProductsPage
                                                                  .routeName,
                                                              arguments: shop))));
                                    });
                                  });
                                },
                                child: new Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                  ),
                                  alignment: Alignment.center,
                                  height: double.infinity,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8),
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'قیمت دهی و فروش',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.local_offer,
                                            color: AppColors.second_color,
                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
                                  Icons.shopping_cart,
                                  color: Colors.grey[700],
                                  size: 18,
                                ),
                                Text(
                                  "  فروشگاه‌های شما ",
                                  style: TextStyle(
                                      color: AppColors.main_color,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                            EdgeInsets.only(top: 16, bottom: 16, right: 10),
                            height: 130,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: state.shops
                                  .map((s) => s.identifier)
                                  .map((s) => _buildSellerItem(s))
                                  .toList(),
                            ),
                          ),
                          Container(
                            color: Colors.grey[100],
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 6, left: 6),
                                  child: Icon(
                                    Icons.local_offer,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'سفارش‌های شما',
                                    style: TextStyle(
                                        color: AppColors.main_color,
                                        fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Card(
                                      child: Row(
                                        children: <Widget>[
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(child: OrdersListWidget()),
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

  Widget _buildOrderListItem(ShopOrder order) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: Text(order.quantity.toString()),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('سفارش'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }

  _showShopSelection(BuildContext context, List<ShopIdentifier> shops,
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
                height: 60,
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
                                Text(shop.centerName),
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
  }

  Widget _buildSellerItem(ShopIdentifier seller) {
    var provinceRepo = Provider.of<ProvinceRepository>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SellerDetailPage(seller)));
      },
      child: Card(
        elevation: 6,
        child: Container(
            alignment: Alignment.centerRight,
            width: 120,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      seller.centerName.toString(),
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
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
                          color: AppColors.main_color,
                        ),
                        padding: EdgeInsets.only(right: 6, left: 7),
                      ),
                      Container(
                        child: Text(
                          provinceRepo.getCityName(seller.cityId),
                          style: TextStyle(color: AppColors.main_color),
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
