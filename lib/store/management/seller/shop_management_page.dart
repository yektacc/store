import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/data_layer/management/management_repository.dart';
import 'package:store/store/home/category_page.dart';
import 'package:store/store/management/model.dart';
import 'package:store/store/management/seller/shop_add_product_page.dart';
import 'package:store/store/management/seller/shop_create_product_page.dart';
import 'package:store/store/management/seller/shop_detail_page.dart';
import 'package:store/store/management/seller/shop_management_bloc.dart';
import 'package:store/store/management/seller/shop_management_event_state.dart';
import 'package:store/store/order/order_page.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';
import 'package:store/store/structure/model.dart';
import 'package:store/store/structure/repository.dart';

class ShopManagementPage extends StatefulWidget {
  final ShopIdentifier _shopIdentifier;

  ShopManagementPage(this._shopIdentifier);

  @override
  _ShopManagementPageState createState() => _ShopManagementPageState();
}

class _ShopManagementPageState extends State<ShopManagementPage> {
  ShopManagementBloc _shopManagementBloc;

  @override
  Widget build(BuildContext context) {
    if (_shopManagementBloc == null) {
      _shopManagementBloc = ShopManagementBloc(
          Provider.of<ManagementRepository>(context),
          widget._shopIdentifier,
          Provider.of<ProductDetailRepository>(context));
      _shopManagementBloc.dispatch(GetShopProducts());
    }

    return Container(
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: CustomAppBar(
            backgroundColor: AppColors.second_color,
            elevation: 0,
            title: Text(
              widget._shopIdentifier.name,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          body: Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                height: 84,
                color: AppColors.second_color,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        /* shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),*/
                        elevation: 5,
                        color: Colors.grey[50],
                        margin: EdgeInsets.only(right: 10, left: 6),
                        child: new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                CreateProductPage.routeName,
                                arguments: widget._shopIdentifier);
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
                                    margin: EdgeInsets.only(
                                        right: 8, bottom: 2, top: 2),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'اضافه کردن محصول',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
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
                        /*shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),*/
                        color: Colors.grey[50],
                        margin: EdgeInsets.only(left: 10, right: 6),
                        child: FlatButton(
                          onPressed: () {
                            Provider.of<StructureRepository>(context)
                                .fetchAsync()
                                .then((pets) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                        AllPets(pets),
                                        () => Navigator.of(context)
                                            .popAndPushNamed(
                                                ShopAddProductsPage.routeName,
                                                arguments:
                                                    widget._shopIdentifier),
                                        altColor: true,
                                      )));
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
                                    margin: EdgeInsets.only(
                                        right: 8, top: 2, bottom: 2),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'قیمت دهی و فروش',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
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
                      padding: EdgeInsets.symmetric(vertical: 7),
                      color: Colors.grey[200],
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
                              'محصولات شما',
                              style: TextStyle(
                                  color: AppColors.second_color, fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShopProductsPage(
                                                      _shopManagementBloc)));
                                    },
                                    child: Text('مشاهده همه'),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          child:
                              BlocBuilder<ShopManagementBloc, ShopManagerState>(
                        bloc: _shopManagementBloc,
                        builder: (context, state) {
                          if (state is ShopDataLoaded) {
                            return _buildProductsRow(state.products);
                          } else {
                            return Container();
                          }
                        },
                      )),
                    )
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      color: Colors.grey[200],
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
                                  color: AppColors.second_color, fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShopOrderPage(
                                                      _shopManagementBloc
                                                          .identifier)));
                                    },
                                    child: Text('مشاهده همه'),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          child:
                              ShopOrdersBriefHWidget(widget._shopIdentifier)),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buildProductsRow(List<DetailedShopProduct> products) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: products.map(_buildShopProductItem).toList(),
    );
  }

  Widget _buildShopProductItem(DetailedShopProduct shopProduct) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      child: (Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        width: 140,
        child: Column(
          children: <Widget>[
            Container(
              height: 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                  color: Colors.grey[100]),
              child: Row(
                children: <Widget>[
                  Padding(
                    child: Text(
                      'موجود :',
                      style: TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.only(right: 5),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 14),
                      child: Text(shopProduct.stockQuantity.toString()),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 25,
              color: Colors.grey[200],
              child: Row(
                children: <Widget>[
                  Padding(
                    child: Text(
                      'فروخته شده :',
                      style: TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.only(right: 5),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 14),
                      child: Text(shopProduct.saleCount.toString()),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 7, horizontal: 3),
                child: Helpers.image(shopProduct.product.img),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.centerRight,
              child: Text(
                shopProduct.product.name,
                style: TextStyle(fontSize: 11),
              ),
            )
          ],
        ),
      )),
    );
  }
}

/*
Widget _buildCenterItem(CenterIdentifier identifier) {
  var provinceRepo = Provider.of<ProvinceRepository>(context);

  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => identifier is ShopIdentifier ?  SellerDetailPage(identifier) : ));
    },
    child: Card(
      elevation: 6,
      child: Container(
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
//                      color: Colors.grey[300],
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
                          provinceRepo.getCityName(identifier.cityId),
                          style: TextStyle(color: AppColors.main_color),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    ),
  );
}*/
