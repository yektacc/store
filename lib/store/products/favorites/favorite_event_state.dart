import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/products/detail/product_detail_model.dart';
import 'package:store/store/products/favorites/model.dart';

@immutable
abstract class FavoriteEvent extends BlocEvent {}

@immutable
abstract class FavoriteState extends BlocState {}

// STATES *******************************

class FavoritesLoading extends FavoriteState {
  FavoritesLoading();

  @override
  String toString() {
    return "STATE: loading favorite favorite";
  }
}

class NotAvailable extends FavoriteState {
  NotAvailable();

  @override
  String toString() {
    return " STATE: user isn't logged in";
  }
}

class FavoritesLoaded extends FavoriteState {
/*  final List<DetailedProduct> detailedProducts;
  final List<Product> products;*/
  final List<FavoriteProduct> products;

  FavoritesLoaded(this.products);

  @override
  String toString() {
    return " STATE: favorites loaded : $products";
  }
}

// EVENTS *******************************
class FetchFavorites extends FavoriteEvent {
  FetchFavorites();
}

class AddFavorite extends FavoriteEvent {
  final DetailedProduct detailProduct;

  AddFavorite(this.detailProduct);
}

class RemoveFavorite extends FavoriteEvent {
  final int favoriteID;

  RemoveFavorite(this.favoriteID);
}
