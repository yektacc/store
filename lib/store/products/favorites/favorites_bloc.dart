import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/store/login_register/login/user.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';

import 'favorite_event_state.dart';
import 'favorite_repository.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final LoginStatusBloc _loginStatusBloc;
  final ProductDetailRepository _detailRepo;
  final FavoriteRepository _favoritesRepo;

  StreamSubscription _streamSubscription;
  User user;

  FavoriteBloc(this._loginStatusBloc, this._favoritesRepo, this._detailRepo) {
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
  }

  @override
  FavoriteState get initialState => NotAvailable();

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FetchFavorites) {
      yield FavoritesLoading();
      if (user != null) {
        var detailProducts = await _favoritesRepo.getAll(user.sessionId);
        var products =
            await _detailRepo.getProductListFromDetailList(detailProducts);
        yield (FavoritesLoaded(detailProducts, products));
      } else {
        yield NotAvailable();
      }
    } else if (event is AddFavorite) {
      yield FavoritesLoading();
      if (user != null) {
        print('alsdjfl' + event.favoriteProduct.id.toString());
        await _favoritesRepo.add(event.favoriteProduct, user.sessionId);
        var detailProducts = await _favoritesRepo.getAll(user.sessionId);
        var products =
            await _detailRepo.getProductListFromDetailList(detailProducts);
        yield (FavoritesLoaded(detailProducts, products));
      } else {
        yield NotAvailable();
      }
    } else if (event is RemoveFavorite) {
      yield FavoritesLoading();
      if (user != null) {
        await _favoritesRepo.remove(event.productId, user.sessionId);
        var detailProducts = await _favoritesRepo.getAll(user.sessionId);
        var products =
            await _detailRepo.getProductListFromDetailList(detailProducts);
        yield (FavoritesLoaded(detailProducts, products));
      } else {
        yield NotAvailable();
      }
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
