import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/products/detail/product_detail_model.dart';
import 'package:store/store/products/favorites/favorites_bloc.dart';
import 'package:store/store/products/favorites/model.dart';

import 'favorite_event_state.dart';

class AddToFavorite extends StatelessWidget {
  final DetailedProduct detailProduct;
  FavoriteBloc _bloc;

  AddToFavorite(this.detailProduct);

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = Provider.of<FavoriteBloc>(context);
    }
    _bloc.dispatch(FetchFavorites());
    return Container(
      height: 60,
      width: 60,
      child: BlocBuilder(
        bloc: _bloc,
        builder: (context, FavoriteState state) {
          print('favorite state: ' + state.toString());

          if (state is FavoritesLoading) {
            return Container(

            );
          } else if (state is FavoritesLoaded) {
            if (state.products.isEmpty) {
              return _buildItem(false);
            } else {
              if (state.products.map((p) => p.id).contains(detailProduct.id)) {
                var favProduct = state.products.firstWhere((
                    favProduct) => favProduct.id == detailProduct.id);
                return _buildItem(true, identifier: favProduct.identifier);
              } else {
                return _buildItem(false);
              }
            }
          } else if (state is NotAvailable) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildItem(bool selected, {FavoriteIdentifier identifier}) {
    assert(selected == false || identifier != null);

    return GestureDetector(
      onTap: () {
        if (!selected) {
          _bloc.dispatch(AddFavorite(detailProduct));
        } else {
          _bloc.dispatch(RemoveFavorite(identifier.id));
        }
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Icon(
          Icons.favorite,
          color: selected ? AppColors.main_color : Colors.grey[400],
        ),
        padding: EdgeInsets.symmetric(horizontal: 22),
      ),
    );
  }
}
