import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/data_layer/fcm/fcm_token_repository.dart';
import 'package:store/store/login_register/login/login_bloc.dart';
import 'package:store/store/login_register/login/login_event_state.dart';

import 'login_status_event_state.dart';

class LoginStatusBloc extends Bloc<LoginStatusEvent, LoginStatusState> {
  final LoginBloc _loginBloc;
  final FcmTokenRepository _fcmRepo;
  StreamSubscription _streamSubscription;

  LoginStatusBloc(this._loginBloc, this._fcmRepo) {
    _streamSubscription = _loginBloc.state.listen((state) {
      if (state is LoginSuccessful) {
        dispatch(UpdateStatus(LoggedInStatus(state.user)));
        _fcmRepo.updateToken(state.user.sessionId);
      } else if (state is LogoutSuccessful) {
        dispatch(UpdateStatus(NotLoggedInStatus()));
      }
    });
  }


  @override
  void onError(Object error, StackTrace stacktrace) {
    print("Login Status Bloc error" + error.toString());
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
    print('new login status event: $event');
    if (event is UpdateStatus) {
      yield* _mapUpdateStatusToState(event);
    } else {
      throw "bad state event: $event";
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
