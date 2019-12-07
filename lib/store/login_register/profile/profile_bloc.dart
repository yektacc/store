import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/login_register/profile/profile_bloc_event_state.dart';
import 'package:store/store/login_register/profile/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;
  final LoginStatusBloc _loginStatusBloc;
  StreamSubscription loginSubscription;

  @override
  void onEvent(ProfileEvent event) {
    print("PRODUCTS_BLOC: new event: $event");
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
    print(stacktrace);
  }

  ProfileBloc(this._repository, this._loginStatusBloc) {
    _loginStatusBloc.state.listen((state) {
      if (state is IsLoggedIn) {
        dispatch(GetProfile(state.user.sessionId));
      } else {
        dispatch(UnloadProfile());
      }
    });
  }

  @override
  ProfileState get initialState => LoadingProfile();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is GetProfile) {
      yield* _mapLoadToState(event);
    } else if (event is UnloadProfile) {
      yield LoadingProfile();
    } else if (event is UpdateProfile) {
      yield LoadingProfile();
      _repository.updateProfile(event.newProfile).then((res) {
        if (res == true) {
          dispatch(GetProfile(event.newProfile.newProfile.sessionId,
              forceUpdate: true));
        } else {}
      });
    }
  }

  Stream<ProfileState> _mapLoadToState(GetProfile event) async* {
    yield LoadingProfile();
    try {
      print("PROFILE BLOC: loading");
      await for (final profile in _repository.load(event.sessionId,
          forceUpdate: event.forceUpdate)) {
        print("PROFILE BLOC: loaded  ${event.sessionId}");

        yield ProfileLoaded(profile);
      }
    } catch (e) {
      print("PROFILE BLOC: failure: " + e.toString());
      yield LoadingProfile();
    }
  }

  @override
  void dispose() {
    loginSubscription.cancel();
  }
}
