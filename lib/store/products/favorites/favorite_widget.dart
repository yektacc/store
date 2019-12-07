import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/products/detail/product_detail_model.dart';
import 'package:store/store/products/favorites/favorites_bloc.dart';
import 'package:provider/provider.dart';

import 'favorite_event_state.dart';

class AddToFavorite extends StatelessWidget {
  final DetailedProduct product;
  FavoriteBloc _bloc;

  AddToFavorite(this.product);

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
          print('alsdjflaksdjdfla' + state.toString());

          if (state is FavoritesLoading) {
            return Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.favorite,
                color: AppColors.grey[400],
              ),
              padding: EdgeInsets.symmetric(horizontal: 22),
            );
          } else if (state is FavoritesLoaded) {
            print('i8yei23yi23y');
            if (state.detailedProducts.isEmpty) {
              return _buildItem(false);
            } else {
              print('asdlfijalsdjdflaksdjdflkakjsddf');
              if (state.detailedProducts.contains(product)) {
                return _buildItem(true);
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

  Widget _buildItem(bool selected) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          print('sdfj');
          _bloc.dispatch(AddFavorite(product));
        } else {
          print('ksjfkdjkfjdkf');
          _bloc.dispatch(RemoveFavorite(int.parse(product.id)));
        }
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Icon(
          Icons.favorite,
          color: selected ? AppColors.second_color : Colors.grey[400],
        ),
        padding: EdgeInsets.symmetric(horizontal: 22),
      ),
    );
  }
}
