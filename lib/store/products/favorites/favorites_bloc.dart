import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/store/login_register/login/user.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/products/product/products_repository.dart';

import 'favorite_event_state.dart';
import 'favorite_repository.dart';
import 'model.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final LoginStatusBloc _loginStatusBloc;
  final ProductsRepository _productsRepo;
  final FavoriteRepository _favoritesRepo;

  StreamSubscription _streamSubscription;
  User user;

  FavoriteBloc(this._loginStatusBloc, this._favoritesRepo, this._productsRepo) {
    _streamSubscription = _loginStatusBloc.state.listen((state) {
      if (state is IsLoggedIn) {
        user = state.user;
        dispatch(FetchFavorites());
      } else if (state is NotLoggedIn) {
        user = null;
        dispatch(FetchFavorites());
      }
    });
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print("ERROR FAVORITES" + error.toString());
    print(stacktrace);
  }

  @override
  FavoriteState get initialState => NotAvailable();

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FetchFavorites) {
      yield FavoritesLoading();
      if (user != null) {
        var products = await _loadProductsByAppUser(user.appUserId);
        yield (FavoritesLoaded(products));
      } else {
        yield NotAvailable();
      }
    } else if (event is AddFavorite) {
      yield FavoritesLoading();
      if (user != null) {
        await _favoritesRepo.add(event.detailProduct, user.appUserId);
        var products = await _loadProductsByAppUser(user.appUserId);
        yield (FavoritesLoaded(products));
      } else {
        yield NotAvailable();
      }
    } else if (event is RemoveFavorite) {
      yield FavoritesLoading();
      if (user != null) {
        await _favoritesRepo.remove(event.favoriteID, user.appUserId);
        var products = await _loadProductsByAppUser(user.appUserId);
        yield (FavoritesLoaded(products));
      } else {
        yield NotAvailable();
      }
    }
  }

  Future<List<FavoriteProduct>> _loadProductsByAppUser(int appUserId) async {
    return await _loadProductsByIdentifier(
        await _favoritesRepo.getAll(user.appUserId));
  }

  Future<List<FavoriteProduct>> _loadProductsByIdentifier(
      List<FavoriteIdentifier> identifiers) async {
    var mappedList = identifiers.map((identifier) async {
      var product = await _productsRepo.loadById(identifier.productId);
      return FavoriteProduct(product, identifier);
    }).toList();

    List<FavoriteProduct> list = await Future.wait(mappedList);
    return list;
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
