import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/login_register/profile/profile_repository.dart';

import 'model.dart';

@immutable
abstract class ProfileEvent extends BlocEvent {}

@immutable
abstract class ProfileState extends BlocState {
  ProfileState([List props = const []]) : super(props);
}

// STATES *******************************

class LoadingProfile extends ProfileState {
  LoadingProfile();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded(this.profile);

  @override
  String toString() {
    return "STATE: loaded: $profile";
  }
}

// EVENTS *******************************

class GetProfile extends ProfileEvent {
  final String sessionId;
  final bool forceUpdate;

  GetProfile(this.sessionId, {this.forceUpdate = false});

  @override
  String toString() {
    return "get profile";
  }
}

class UnloadProfile extends ProfileEvent {
  UnloadProfile();

  @override
  String toString() {
    return "Unload profile";
  }
}

class UpdateProfile extends ProfileEvent {
  final EditRequest newProfile;

  UpdateProfile(this.newProfile);

  @override
  String toString() {
    return "update profile, new values: " + newProfile.toString();
  }
}
