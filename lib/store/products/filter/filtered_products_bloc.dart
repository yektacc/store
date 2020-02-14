import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/products/product/products_bloc.dart';
import 'package:store/store/products/product/products_bloc_event.dart';

import 'filter.dart';
import 'filtered_products_bloc_event.dart';

class FilteredProductsBloc
    extends Bloc<FilteredProductsEvent, FilteredProductsState> {
/*
  final ProductsRepository _repository;
*/
/*
  final FilterInteractor _filterInteractor;
*/
  final ProductsBloc productsBloc;
  StreamSubscription productsSubscription;

  @override
  void onEvent(FilteredProductsEvent event) {
    print("centerData: new event: $event");
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print("FILTERED_PRODUCTS_BLOC ERROR " + error.toString());
    print(stacktrace);
  }

  FilteredProductsBloc(/*this._filterInteractor,*/ this.productsBloc) {
    productsSubscription = productsBloc.state.listen((state) {
      if (state is ProductsLoaded) {
        dispatch(UpdateFilteredProductsBlocProducts(state.products));
      }
    });
  }

  @override
  FilteredProductsState get initialState =>
      productsBloc.currentState is ProductsLoaded
          ? FilteredProductsLoaded(
              (productsBloc.currentState as ProductsLoaded).products)
          : LoadingFilteredProducts();

  @override
  Stream<FilteredProductsState> mapEventToState(
      FilteredProductsEvent event) async* {
    if (event is UpdateFilteredProductsBlocProducts) {
      yield* _mapProductsUpdatedToState(currentState, event);
    } else if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(currentState, event);
    }
  }

  Stream<FilteredProductsState> _mapUpdateFilterToState(
      FilteredProductsState currentState, UpdateFilter event) async* {
    yield LoadingFilteredProducts();
    if (productsBloc.currentState is ProductsLoaded) {
      if (event.filter.isEmpty()) {
        yield FilteredProductsLoaded(
            (productsBloc.currentState as ProductsLoaded).products);
      } else {
        yield FilteredProductsLoaded(
          _mapProductsToFilteredProducts(
              (productsBloc.currentState as ProductsLoaded).products,
              event.filter),
        );
      }
    }
  }

  Stream<FilteredProductsState> _mapProductsUpdatedToState(
      FilteredProductsState currentState,
      UpdateFilteredProductsBlocProducts event) async* {
    /*final List<FilterData> lastOptions =
        currentState is FilteredProductsLoaded ? currentState.options : [];*/
    yield LoadingFilteredProducts();

    List<Product> products =
        (productsBloc.currentState as ProductsLoaded).products;

    yield FilteredProductsLoaded(
        _mapProductsToFilteredProducts(products, FilterData()));
  }

  List<Product> _mapProductsToFilteredProducts(
      List<Product> products, FilterData filter) {
    List<Product> filteredProducts = products;


    if (filter.minPrice != null) {
      filteredProducts = filteredProducts
          .where((p) => p.price.compareTo(filter.minPrice) >= 0)
          .toList();
    }

    if (filter.maxPrice != null) {
      filteredProducts = filteredProducts
          .where((p) => p.price.compareTo(filter.maxPrice) <= 0)
          .toList();
    }

    if (filter.brands != null && filter.brands.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((p) => filter.brands.contains(p.brand))
          .toList();
    }

    if (filter.sort != null) {
      switch (filter.sort) {
        case SortingType.BY_PRICE_ASC:
          filteredProducts.sort((p1,p2) => p1.price.compareTo(p2.price));
          break;
        case SortingType.BY_PRICE_DES:
          filteredProducts.sort((p1,p2) => p2.price.compareTo(p1.price));
          break;
        case SortingType.BY_RATE:
          break;
        case SortingType.BY_LOCATION:
          break;
        case SortingType.NONE:
          break;
      }
    }

    return filteredProducts;
  }

  @override
  void dispose() {
    productsSubscription.cancel();
    super.dispose();
  }
}
