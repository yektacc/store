import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';

import 'model.dart';

@immutable
abstract class StructureEvent extends BlocEvent {}

@immutable
abstract class StructureState extends BlocState {}

// STATES *******************************

class LoadingStructure extends StructureState {
  LoadingStructure();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class LoadedStructure extends StructureState {
  final List<StructPet> pets;

  LoadedStructure(this.pets);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class FailureStructure extends StructureState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class FetchStructure extends StructureEvent {
  @override
  String toString() {
    return "fetch";
  }
}
