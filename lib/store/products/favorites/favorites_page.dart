import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/store/products/favorites/favorite_event_state.dart';
import 'package:store/store/products/favorites/favorites_bloc.dart';
import 'package:store/store/products/favorites/model.dart';
import 'package:store/store/products/product/product_item_wgt.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  FavoriteBloc _favoriteBloc;
  final List<Widget> _list = [];

  @override
  Widget build(BuildContext context) {
    _favoriteBloc ??= Provider.of<FavoriteBloc>(context);
    _favoriteBloc.dispatch(FetchFavorites());

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'علاقه‌مندی ها',
      ),
      body: Container(
        child: BlocBuilder(
          bloc: _favoriteBloc,
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return LoadingIndicator();
            } else if (state is NotAvailable) {
              return Text('محصولی موجود نیست!');
            } else if (state is FavoritesLoaded) {
              if (state.products.isEmpty) {
                return Center(
                  child: Text('لیست علاقه‌مندی ها خالی است'),
                );

                /* var favoriteList = state.products.map((fp) async {
                  var widget = await (fp);
                  return widget;
                });

                Future.wait(favoriteList).then((list) {
                  setState(() {
                    _list.clear();
                    _list.addAll(list);
                  });
                });
                return Container();*/
              } else {
                return ListView(
                    children: state.products.map(_buildFavoriteItem).toList());
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void _remove(FavoriteProduct product) {
    _favoriteBloc.dispatch(RemoveFavorite(product.identifier.id));
  }

  Widget _buildFavoriteItem(FavoriteProduct product) {
    return Column(
      children: <Widget>[
        ProductListItem(
          product,
          0,
          purchasable: false,
          header: Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          '${product.subCategory.petName} / ${product
                              .subCategory.catName} / ${product.subCategory
                              .nameFA}',
                          style: TextStyle(
                              color: AppColors.text_main, fontSize: 13),
                        ),
                        padding: EdgeInsets.only(right: 8),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 9, top: 8),
                      padding: EdgeInsets.only(
                          right: 10, left: 8, top: 7, bottom: 7),
                      decoration: BoxDecoration(
                          color: AppColors.main_color,
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                      child: GestureDetector(
                        onTap: () {
                          _remove(product);
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              'حذف',
                              style:
                              TextStyle(fontSize: 11, color: Colors.white),
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 19,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(right: 8),
                  alignment: Alignment.centerRight,
                  child: Text(
                      Helpers.getPersianDate(product.identifier.addedDate)),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4), topLeft: Radius.circular(4))),
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
