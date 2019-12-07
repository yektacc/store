import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/products/product/product.dart';

import 'filter.dart';

@immutable
abstract class FilteredProductsEvent extends BlocEvent {}

@immutable
abstract class FilteredProductsState extends BlocState {
  FilteredProductsState([List props = const []]) : super(props);
}

// STATES *******************************

class LoadingFilteredProducts extends FilteredProductsState {
  LoadingFilteredProducts();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class FilteredProductsLoaded extends FilteredProductsState {
  final List<Product> filteredProducts;
/*
  final List<FilterData> options;
*/

  FilteredProductsLoaded(this.filteredProducts/*, this.options*/);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class FilteredProductsFailure extends FilteredProductsState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class UpdateFilter extends FilteredProductsEvent {
  final FilterData filter;

  UpdateFilter(this.filter);

  @override
  String toString() {
    return "new filters: $filter";
  }
}

class UpdateFilteredProductsBlocProducts extends FilteredProductsEvent {
  final List<Product> products;

  UpdateFilteredProductsBlocProducts(this.products);

  @override
  String toString() => "update products: $products";
}
