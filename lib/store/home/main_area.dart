import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/data_layer/ads/ads_repository.dart';
import 'package:store/data_layer/tags/tag_item_repository.dart';
import 'package:store/store/home/pet_selection.dart';
import 'package:store/store/home/product_grid_list.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/products/favorites/favorite_event_state.dart';
import 'package:store/store/products/favorites/favorites_bloc.dart';
import 'package:store/store/products/product/product_grid_item.dart';
import 'package:store/store/products/special/special_products_repository.dart';
import 'package:provider/provider.dart';

import 'ad_item_wgt.dart';

class MainArea extends StatefulWidget {
  @override
  _MainAreaState createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  @override
  Widget build(BuildContext context) {
    var loginState = Provider.of<LoginStatusBloc>(context).currentState;

    return ListView(
      children: <Widget>[
        loginState is IsLoggedIn
            ? BlocBuilder<FavoriteBloc, FavoriteState>(
                bloc: Provider.of<FavoriteBloc>(context),
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return Container();
                  } else if (state is FavoritesLoaded) {
                    return ProductGridList(
                        'علاقه‌مندی های شما', Future.value(state.products));
                  } else {
                    return Container();
                  }
                },
              )

            /*FutureBuilder<List<DetailedProduct>>(
          future: Provider.of<FavoriteRepository>(context)
              .getAll(loginState.user.sessionId), builder: (context, snapshot) {
          Future<List<Product>> products = snapshot.data.map((dp) =>
              Provider.of<ProductDetailRepository>(context).getProductById(
                  dp.id)).toList();

          return ProductGridList(

            'علاقه‌مندی های شما',
          )
        },)*/

            /**/ : Container(),
        Container(
          margin: EdgeInsets.only(top: 8),
          color: Colors.grey[300],
          child: new Container(
            height: 350,
            margin: EdgeInsets.only(),
            child: FutureBuilder(
              future: Provider.of<TagsRepository>(context).getTagItems(),
              builder: (context, AsyncSnapshot<List<TagItem>> snapshot) {
                if (snapshot == null) {
                  return LoadingIndicator();
                } else if (snapshot.data != null && snapshot.data.isNotEmpty) {
                  return Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.symmetric(horizontal: 9),
                        height: 56,
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.only(),
                          child: Container(
                            height: 56,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                  padding: EdgeInsets.only(right: 12),
                                  height: 38,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "شب یلدا سال 98  ",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Card(
                                                elevation: 6,
                                                color: AppColors.second_color,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: Text(
                                                        "فروش ویژه",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Icon(
                                                        Icons.local_offer,
                                                        size: 17,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: AppColors.grey[200],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data[0].products
                              .map((p) => ProductGridItem(p))
                              .toList(),
                        ),
                      )
                    ],
                  );
                } else {
                  return Text("");
                }
              },
            ),
          ),
        ),
        Container(
          child: Container(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 12, right: 12),
                    height: 38,
                    child: Text(
                      "دسته بندی حیوانات",
                      style: TextStyle(
                          color: Colors.grey[900], fontWeight: FontWeight.bold),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15))))
              ],
            ),
          ),
        ),
        PetSelection(),
        Divider(),
        new Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.symmetric(horizontal: 9),
              height: 56,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(),
                  child: Container(
                    height: 56,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          height: 38,
                          child: Container(
                            width: 140,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "تبلیغات",
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                /*Icon(
                                  Icons.local_offer,
                                  color: Colors.grey[100],
                                )*/
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 225,
              margin: EdgeInsets.only(),
              child: FutureBuilder<List<Ad>>(
                future: Provider.of<AdsRepository>(context).fetch(),
                builder: (context, AsyncSnapshot<List<Ad>> snapshot) {
                  if (snapshot == null) {
                    return LoadingIndicator();
                  } else if (snapshot.data != null &&
                      snapshot.data.isNotEmpty) {
                    return Container(
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data
                              .toList()
                              .map((ad) => AdItemWgt(ad))
                              .toList()),
                    );
                  } else {
                    return Text("");
                  }
                },
              ),
            ),
          ],
        ),
        new ProductGridList(
            'پرفروش‌ترین محصولات',
            Provider.of<SpecialProductsRepository>(context)
                .getSpecialProducts(SpecialProductType.BEST_SELLER)),
        new ProductGridList(
            'جدیدترین محصولات',
            Provider.of<SpecialProductsRepository>(context)
                .getSpecialProducts(SpecialProductType.NEWEST)),
        Padding(
          padding: EdgeInsets.only(bottom: 60),
        )
      ],
    );
  }
}
