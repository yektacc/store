import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/products/product/products_repository.dart';
import 'package:store/store/products/search/search_interactor.dart';
import 'package:store/store/structure/model.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductsRepository _productsRepo;
  final SearchInteractor _interactor;
  StreamSubscription _streamSubscription;

  @override
  void onEvent(SearchEvent event) {
    print("NEW SEARCH EVENT: $event");
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print("SEARCH_BLOC: error: ");
    print(error);
    print(stacktrace);
  }

  SearchBloc(this._productsRepo, this._interactor);

  @override
  SearchState get initialState => LoadingResults();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchFor) {
      yield* _mapSearchForToState(currentState, event);
    }
  }

  Stream<SearchState> _mapSearchForToState(
      SearchState currentState, SearchFor event) async* {
    yield LoadingResults();

    await for (final allProducts in _productsRepo.load(event.identifier)) {
      print('loaded all products : ${event.identifier.getName()} $allProducts');
      var result = _interactor.search(allProducts, event.query);

      if (result.isEmpty) {
        yield NoResult();
      } else {
        yield SearchLoaded(result);
      }
    }

    /*  if (_productsRepo.currentState is ProductsLoaded) {
      List<Product> results =
          (_productsRepo.currentState as ProductsLoaded).products;
      if (results.isEmpty) {
        yield NoResult();
      } else {
        yield SearchLoaded(_interactor.search(results, event.query));
      }
    }*/
  }
}

@immutable
abstract class SearchEvent extends BlocEvent {}

@immutable
abstract class SearchState extends BlocState {
  SearchState([List props = const []]) : super(props);
}

// STATES *******************************
class Idle extends SearchState {
  Idle();

  @override
  String toString() {
    return "STATE: idle";
  }
}

class LoadingResults extends SearchState {
  LoadingResults();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class SearchLoaded extends SearchState {
  final List<Product> results;

  SearchLoaded(this.results);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class SearchFailed extends SearchState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

class NoResult extends SearchState {
  @override
  String toString() {
    return "STATE: no result";
  }
}

// EVENTS *******************************

class SearchFor extends SearchEvent {
  final String query;
  final Identifier identifier;

  SearchFor(this.query, this.identifier);

  @override
  String toString() {
    return "search: query: $query";
  }
}
