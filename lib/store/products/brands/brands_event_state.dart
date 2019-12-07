import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';


@immutable
abstract class BrandsEvent extends BlocEvent {}

@immutable
abstract class BrandsState extends BlocState {}

// STATES *******************************

class LoadingBrands extends BrandsState {
  LoadingBrands();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class LoadedBrands extends BrandsState {
  final List<String> brands;

  LoadedBrands(this.brands);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class BrandsFailed extends BrandsState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class FetchBrands extends BrandsEvent {
  @override
  String toString() {
    return "fetch";
  }
}
