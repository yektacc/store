import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/store/login_register/register/register_bloc.dart';
import 'package:store/store/login_register/register/register_event_state.dart';

import 'login_event_state.dart';
import 'login_interactor.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _interactor;
  final RegisterBloc _registerBloc;
  StreamSubscription _streamSubscription;

  LoginBloc(this._interactor, this._registerBloc) {
    _streamSubscription = _registerBloc.state.listen((state) {
      if (state is RegisterSuccessful) {
        dispatch(AttemptLogin(state.phone, state.pass));
      }
    });
  }

  @override
  void onEvent(LoginEvent event) {
    print("NEW LOGIN EVENT: $event");
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print("LOGIN BLOC ERROR: $error $stacktrace");
  }

  @override
  LoginState get initialState => LoadingLoginAttempt();

  Stream<LoginState> _mapAttemptLoginToState(AttemptLogin event) async* {
    yield (LoadingLoginAttempt());
    var res = await _interactor.attemptLogin(event.phoneNo, event.password);
    if (res is LoginSuccessfulResponse) {
      yield (LoginSuccessful(res.user));
    } else if (res is LoginFailedResponse) {
      yield (LoginFailed(res.error));
    }
  }

  Stream<LoginState> _mapAttemptLastLoginToState(
      AttemptLastLogin event) async* {
    yield (LoadingLoginAttempt());
    var res = await _interactor.attemptLastLogin();
    print("last login bloc: $res");

  /*  if(user != null) {
      dispatch(AttemptLogin(user.phoneNo, user.password));
    }*/


    if (res is LoginSuccessfulResponse) {
      yield (LoginSuccessful(res.user));
    } else if (res is LoginFailedResponse) {
      yield (LoginFailed(res.error));
    }
  }

  Stream<LoginState> _mapAttemptLogoutToState(Logout event) async* {
    yield (LoadingLoginAttempt());
    await _interactor.logout();
    yield (LogoutSuccessful());
    yield LoginFailed(LoginError.UNKNOWN_ERROR);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is AttemptLogin) {
      yield* _mapAttemptLoginToState(event);
    } else if (event is AttemptLastLogin) {
      yield* _mapAttemptLastLoginToState(event);
    } else if (event is Logout) {
      yield* _mapAttemptLogoutToState(event);
    }
    /*else if (event is Reset) {
      yield (LoginFailed(LoginError.NOT_LOGGED_IN));
    }*/
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
  }
}
