import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/store/login_register/login/login_bloc.dart';
import 'package:store/store/login_register/login/login_event_state.dart';
import 'package:store/store/login_register/login/user.dart';

import 'login_status_event_state.dart';

class LoginStatusBloc extends Bloc<LoginStatusEvent, LoginStatusState> {
  final LoginBloc _loginBloc;
  StreamSubscription _streamSubscription;

  LoginStatusBloc(this._loginBloc) {
    _streamSubscription = _loginBloc.state.listen((state) {
      print("23l232323:" + state.toString());
      if (state is LoginSuccessful) {
        dispatch(UpdateStatus(LoggedInStatus(state.user)));
      } else if (state is LogoutSuccessful) {
        dispatch(UpdateStatus(NotLoggedInStatus()));
      }
    });
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print("ERRRRRRR" + error.toString());
  }

  @override
  LoginStatusState get initialState =>
      _loginBloc.currentState is LoginSuccessful
          ? IsLoggedIn((_loginBloc.currentState as LoggedInStatus).user)
          : NotLoggedIn();

  Stream<LoginStatusState> _mapUpdateStatusToState(UpdateStatus event) async* {
    if (event.status is LoggedInStatus) {
      yield IsLoggedIn((event.status as LoggedInStatus).user);
    } else {
      yield NotLoggedIn();
    }
  }

  @override
  Stream<LoginStatusState> mapEventToState(LoginStatusEvent event) async* {
    print("422");
    print("2355" + event.toString());
    if (event is UpdateStatus) {
      print("23535" + event.toString());
      yield* _mapUpdateStatusToState(event);
/*
      yield StatusLoadedFailed(LoggedInStatus(User("23", '23', '2')));
*/
    } else {
      throw "bad state event: $event";
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

/*@override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is AttemptLogin) {
      yield (LoadingLoginAttempt());
      var res = await _interactor.attemptLogin(event.phoneNo, event.password);
      print("ress:  " + res.toString());
      if (res is LoginSuccessful) {
        yield (LoginSuccessful(res.user));
      } else if (res is LoginFailed) {
        yield (LoginFailed(res.error));
      }
    } else if (event is AttemptLastLogin) {
      yield (LoadingLoginAttempt());
      var res = await _interactor.attemptLastLogin();
      print("last login bloc: $res");
      if (res is LoginSuccessful) {
        yield (LoginSuccessful(res.user));
      } else if (res is LoginFailed) {
        yield (LoginFailed(res.error));
      }
    }
  }*/

}
