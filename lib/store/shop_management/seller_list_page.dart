import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/data_layer/shop_management/seller_repository.dart';
import 'package:store/store/home/category_page.dart';
import 'package:store/store/shop_management/seller_add_product_page.dart';
import 'package:store/store/shop_management/seller_detail_page.dart';
import 'package:store/store/structure/model.dart';
import 'package:store/store/structure/repository.dart';
import 'package:provider/provider.dart';

import 'create_product_page.dart';

class SellersListPage extends StatefulWidget {
  static const String routeName = 'sellerpage';

  final List<Shop> sellers;

  SellersListPage(this.sellers);

  @override
  _SellersListPageState createState() => _SellersListPageState();
}

class _SellersListPageState extends State<SellersListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "فروشگاه ها",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        body: Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(top: 13),
              height: 80,
              color: Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Card(
                      elevation: 5,
                      color: Colors.grey[50],
                      margin: EdgeInsets.only(right: 10, left: 6),
                      child: new FlatButton(
                        onPressed: () {
                          _showShopSelection(context, widget.sellers, (shop) {
                            Navigator.of(context).pushNamed(
                                CreateProductPage.routeName,
                                arguments: shop);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 1))),
                          alignment: Alignment.center,
                          height: double.infinity,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 12, bottom: 8),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'اضافه کردن محصول',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                              Container(
                                width: 60,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.add_box,
                                    color: Colors.grey[500],
                                    size: 35,
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
                      color: Colors.grey[50],
                      margin: EdgeInsets.only(left: 10, right: 6),
                      child: FlatButton(
                        onPressed: () {
                          Provider.of<StructureRepository>(context)
                              .fetch()
                              .listen((pets) {
                            _showShopSelection(context, widget.sellers, (shop) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                      AllPets(pets),
                                      () => Navigator.of(context)
                                          .popAndPushNamed(
                                              SellerAddProductsPage.routeName,
                                              arguments: shop))));
                            });
                          });
                        },
                        child: new Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 1))),
                          alignment: Alignment.center,
                          height: double.infinity,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 12, bottom: 8),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'قیمت دهی و فروش',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                              Container(
                                width: 60,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.local_offer,
                                    color: Colors.grey[500],
                                    size: 35,
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
              child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  margin: EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8))),
                        padding: EdgeInsets.only(right: 12, top: 7, bottom: 7),
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.shopping_cart,
                              color: Colors.grey,
                              size: 18,
                            ),
                            Text(
                              "  فروشگاه های شما ",
                              style: TextStyle(
                                  color: AppColors.main_color, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                          child: ListView(
                            children: widget.sellers
                                .map((s) => _buildSellerItem(s))
                                .toList(),
                          ),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  _showShopSelection(
      BuildContext context, List<Shop> shops, Function(Shop) onShopTapped) {
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
                                  onPressed: () => onShopTapped(shop),
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

  Widget _buildSellerItem(Shop seller) {
    var provinceRepo = Provider.of<ProvinceRepository>(context);

    return Container(
        child: Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: 50,
                      child: Text(
                        seller.centerName.toString(),
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height: 20,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.grey[500],
                        ),
                        Container(
                          child: Text(provinceRepo.getCityName(seller.cityId)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
                child: Card(
              color: AppColors.main_color,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SellerDetailPage(seller)));
                },
                child: Container(
                  child: Text(
                    "مشاهده محصولات",
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
              ),
            ))
          ],
        ),
        Divider()
      ],
    ));
  }
}
