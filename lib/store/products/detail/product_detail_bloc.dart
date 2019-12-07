import 'package:bloc/bloc.dart';
import 'package:store/store/products/detail/product_detail_bloc_event.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductDetailRepository _repository;

  @override
  void onEvent(ProductDetailEvent event) {
    print("PRODUCTS_BLOC: new event: $event");
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
    print(stacktrace);
  }

  ProductDetailBloc(this._repository);

  @override
  ProductDetailState get initialState => LoadingProductDetail();

  @override
  Stream<ProductDetailState> mapEventToState(ProductDetailEvent event) async* {
    if (event is LoadProductDetail) {
      yield* _mapLoadToState(event);
    }
  }

  Stream<ProductDetailState> _mapLoadToState(LoadProductDetail event) async* {
    yield LoadingProductDetail();
    try {
     var detail = await _repository.load(event.id);
     yield ProductDetailLoaded(detail);
    } catch (e) {
      print("PRODUCT_DETAIL_BLOC: failure: " + e.toString());
      yield ProductDetailFailure();
    }
  }

/*Stream<ProductDetailState> _mapLoadPopularToState(
      LoadPopularProductDetail event) async* {
    yield LoadingProductDetail();
    await for (final snapshot in _repository.load(event.identifier)) {
      yield ProductDetailLoaded(snapshot);
    }
  }*/
}
