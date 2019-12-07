import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/products/detail/product_detail_model.dart';

@immutable
abstract class ProductDetailEvent extends BlocEvent {}

@immutable
abstract class ProductDetailState extends BlocState {
  ProductDetailState([List props = const []]) : super(props);
}

// STATES *******************************

class LoadingProductDetail extends ProductDetailState {
  LoadingProductDetail();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class ProductDetailLoaded extends ProductDetailState {
  final DetailedProduct detailedProduct;

  ProductDetailLoaded(this.detailedProduct);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class ProductDetailFailure extends ProductDetailState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class LoadProductDetail extends ProductDetailEvent {
  final String id;

  LoadProductDetail(this.id);

  @override
  String toString() {
    return "load product detail event";
  }
}
