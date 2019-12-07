import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';

import 'model.dart';

@immutable
abstract class AdoptionPetsEvent extends BlocEvent {}

@immutable
abstract class AdoptionPetsState extends BlocState {}

// STATES *******************************

class AdoptionPetsLoading extends AdoptionPetsState {
  AdoptionPetsLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class AdoptionPetsLoaded extends AdoptionPetsState {
  final List<AdoptionPet> adoptionPets;

  AdoptionPetsLoaded(this.adoptionPets);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class AdoptionPetsLoadingFailed extends AdoptionPetsState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class FetchAdoptionPets extends AdoptionPetsEvent {
  FetchAdoptionPets();

  @override
  String toString() {
    return "fetch";
  }
}

class RegisterAdoptionPet extends AdoptionPetsEvent {
  final AdoptionPet adoptionPet;

  RegisterAdoptionPet(this.adoptionPet);
}

class EditAdoptionPets extends AdoptionPetsEvent {
  final AdoptionPet adoptionPet;

  EditAdoptionPets(this.adoptionPet);
}

class RemoveAdoptionPets extends AdoptionPetsEvent {
  final String id;

  RemoveAdoptionPets(this.id);
}
