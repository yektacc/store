import 'package:bloc/bloc.dart';
import 'package:store/store/products/product/products_bloc_event.dart';
import 'package:store/store/products/product/products_repository.dart';
import 'package:store/store/structure/model.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository _repository;
  Identifier currentIdentifier;

  @override
  void onEvent(ProductsEvent event) {
    print("PRODUCTS_BLOC: new event: $event");
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
    print(stacktrace);
  }

  ProductsBloc(this._repository);

  @override
  ProductsState get initialState => LoadingProducts();

  @override
  Stream<ProductsState> mapEventToState(ProductsEvent event) async* {
    if (event is LoadProducts) {
      yield* _mapLoadToState(event);
    } else if (event is LoadPopularProducts) {
      yield* _mapLoadPopularToState(event);
    }
  }

  Stream<ProductsState> _mapLoadToState(LoadProducts event) async* {
    yield LoadingProducts();
    try {
      await for (final items in _repository.load(event.identifier)) {
        currentIdentifier = event.identifier;
        yield ProductsLoaded(items);
      }
    } catch (e) {
      print("PRODUCT_BLOC: failure: " + e.toString());
      yield ProductsFailure();
    }
  }

  Stream<ProductsState> _mapLoadPopularToState(
      LoadPopularProducts event) async* {
    yield LoadingProducts();
    await for (final snapshot in _repository.load(event.identifier)) {
      yield ProductsLoaded(snapshot);
    }
  }
}
