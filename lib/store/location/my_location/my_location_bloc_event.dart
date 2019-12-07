import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';

import 'model.dart';

@immutable
abstract class MyLocationEvent extends BlocEvent {}

@immutable
abstract class MyLocationState extends BlocState {}

// STATES *******************************

class MyLocationLoading extends MyLocationState {
  MyLocationLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class MyLocationLoaded extends MyLocationState {
  final Location myLocation;

  MyLocationLoaded(this.myLocation);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class MyLocationUnspecified extends MyLocationState {
  @override
  String toString() {
    return "location not specified";
  }
}

class MyLocationLoadingFailed extends MyLocationState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class FetchMyLocation extends MyLocationEvent {
  FetchMyLocation();

  @override
  String toString() {
    return "fetch";
  }
}

class UpdateMyLocation extends MyLocationEvent {
  final Location newLocation;

  UpdateMyLocation(this.newLocation);

  @override
  String toString() {
    return "update";
  }
}

class RemoveMyLocation extends MyLocationEvent {
  @override
  String toString() {
    return "remove my location";
  }
}
