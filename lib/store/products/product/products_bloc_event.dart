import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/structure/model.dart';

@immutable
abstract class ProductsEvent extends BlocEvent {}

@immutable
abstract class ProductsState extends BlocState {
  ProductsState([List props = const []]) : super(props);
}

// STATES *******************************

class LoadingProducts extends ProductsState {
  LoadingProducts();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final Identifier identifier;

  ProductsLoaded(this.products, this.identifier);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class ProductsFailure extends ProductsState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class LoadProducts extends ProductsEvent {
  final Identifier identifier;

  LoadProducts(this.identifier);

  @override
  String toString() {
    return "load products event";
  }
}

class LoadPopularProducts extends ProductsEvent {
  final Identifier identifier;

  LoadPopularProducts(this.identifier);

  @override
  String toString() => "load popular products evet";
}
