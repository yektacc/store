import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/data_layer/userpet/user_pet_repository.dart';

@immutable
abstract class UserPetEvent extends BlocEvent {}

@immutable
abstract class UserPetState extends BlocState {}

// STATES *******************************

class UserPetLoading extends UserPetState {
  UserPetLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class UserPetNotSet extends UserPetState {
  @override
  String toString() {
    return "user pet not set";
  }
}

class UserPetLoaded extends UserPetState {
  final UserPet userPet;

  UserPetLoaded(this.userPet);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class UserPetLoadingFailed extends UserPetState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class FetchUserPet extends UserPetEvent {
  FetchUserPet();

  @override
  String toString() {
    return "fetch";
  }
}

class SetUserPet extends UserPetEvent {
  final int id;
  final int age;
  final int sterilization;
  final int gender;
  final int typeId;
  final String name;

  SetUserPet(this.id, this.age, this.sterilization, this.gender, this.typeId,
      this.name);
}

class RemoveUserPet extends UserPetEvent {
  final int id;

  RemoveUserPet(this.id);
}
