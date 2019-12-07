import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';

import '../../data_layer/centers/centers_repository.dart';
import 'model.dart';

@immutable
abstract class CentersEvent extends BlocEvent {}

@immutable
abstract class CentersState extends BlocState {}

// STATES *******************************

class CentersLoading extends CentersState {
  CentersLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class CentersLoaded extends CentersState {
  final List<CenterItem> centers;

  CentersLoaded(this.centers);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class CentersLoadingFailed extends CentersState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class FetchCenters extends CentersEvent {
  final CenterFetchType type;

  FetchCenters(this.type);

  @override
  String toString() {
    return "fetch";
  }
}

class Reset extends CentersEvent {}

/*
class RegisterCenter extends CentersEvent {
  final CenterItem clinic;

  RegisterCenter(this.clinic);
}

class EditCenters extends CentersEvent {
  final CenterItem clinic;

  EditCenters(this.clinic);
}

class RemoveCenters extends CentersEvent {
  final String id;

  RemoveCenters(this.id);
}
*/
