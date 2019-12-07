import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/products/detail/product_detail_model.dart';
import 'package:store/store/products/product/product.dart';

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
  final List<DetailedProduct> detailedProducts;
  final List<Product> products;

  FavoritesLoaded(this.detailedProducts, this.products);

  @override
  String toString() {
    return " STATE: user is logged in : $detailedProducts";
  }
}

// EVENTS *******************************
class FetchFavorites extends FavoriteEvent {
  FetchFavorites();
}

class AddFavorite extends FavoriteEvent {
  final DetailedProduct favoriteProduct;

  AddFavorite(this.favoriteProduct);
}

class RemoveFavorite extends FavoriteEvent {
  final int productId;

  RemoveFavorite(this.productId);
}