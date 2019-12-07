import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/products/detail/product_detail_model.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';
import 'package:store/store/products/favorites/favorite_event_state.dart';
import 'package:store/store/products/favorites/favorites_bloc.dart';
import 'package:store/store/products/product/product_item_wgt.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text('علاقه‌مندی ها'),),
      body: Container(
        child: BlocBuilder(
          bloc: _favoriteBloc,
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return LoadingIndicator();
            } else if (state is NotAvailable) {
              return Text('محصولی موجود نیست!');
            } else if (state is FavoritesLoaded) {
              if (_list.isEmpty) {
                var favoriteList = state.detailedProducts.map((dp) async {
                  var widget = await _buildFavoriteItem(dp);
                  return widget;
                });

                Future.wait(favoriteList).then((list) {
                  setState(() {
                    _list.clear();
                    _list.addAll(list);
                  });
                });
                return Container();
              } else {
                return ListView(children: _list);
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<Widget> _buildFavoriteItem(DetailedProduct productDetail) async {
    var detailRepo = Provider.of<ProductDetailRepository>(context);
    var product = await detailRepo.getProductById(productDetail.id);
    return ProductListItem(product, 0, purchasable: false);
  }
}
