import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';

import 'lost_pets_repository.dart';
import 'model.dart';

@immutable
abstract class LostPetsEvent extends BlocEvent {}

@immutable
abstract class LostPetsState extends BlocState {}

// STATES *******************************

class LostPetsLoading extends LostPetsState {
  LostPetsLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class LostPetsLoaded extends LostPetsState {
  final List<LostPet> lostPets;

  LostPetsLoaded(this.lostPets);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class LostPetsLoadingFailed extends LostPetsState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class Reset extends LostPetsEvent {}

class FetchLostPets extends LostPetsEvent {
  final PetRequestType type;

  FetchLostPets(this.type);

  @override
  String toString() {
    return "fetch";
  }
}

class RegisterLostPet extends LostPetsEvent {
  final LostPet lostPet;

  RegisterLostPet(this.lostPet);
}

class EditLostPets extends LostPetsEvent {
  final LostPet lostPet;

  EditLostPets(this.lostPet);
}

class RemoveLostPets extends LostPetsEvent {
  final String id;

  RemoveLostPets(this.id);
}
