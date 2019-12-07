import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';

import 'model.dart';

@immutable
abstract class ProvinceEvent extends BlocEvent {}

@immutable
abstract class ProvinceState extends BlocState {}

// STATES *******************************

class ProvincesLoading extends ProvinceState {
  ProvincesLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class ProvincesLoaded extends ProvinceState {
  final List<Province> provinces;

  ProvincesLoaded(this.provinces);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class ProvinceLoadingFailed extends ProvinceState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class FetchProvinces extends ProvinceEvent {
  FetchProvinces();

  @override
  String toString() {
    return "fetch";
  }
}
