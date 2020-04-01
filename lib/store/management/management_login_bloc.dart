import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/data_layer/fcm/fcm_token_repository.dart';
import 'package:store/data_layer/management/management_repository.dart';
import 'package:store/store/management/model.dart';

import 'management_login_event_state.dart';

class ManagerLoginBloc extends Bloc<ManagerLoginEvent, ManagerLoginState> {
  final ManagementRepository _managementRepo;
  final FcmTokenRepository _fcmRepo;

  StreamSubscription _streamSubscription;

  ManagerLoginBloc(this._managementRepo, this._fcmRepo);

  @override
  void onError(Object error, StackTrace stacktrace) {
    print("Management Bloc Error" + error.toString());
    print(stacktrace);
  }

  @override
  ManagerLoginState get initialState => SMWaitingForLogin();

  @override
  Stream<ManagerLoginState> mapEventToState(ManagerLoginEvent event) async* {
    if (event is ShopManagerLogin) {
      yield LoadingSMData();
      var identifiers =
          await _managementRepo.loginSeller(event.email, event.password);

      print("center identifiers: " + identifiers.toString());

      try {
        var service = identifiers
            .firstWhere((identifier) => identifier is ServiceIdentifier);

        if (service != null) {
          _fcmRepo.updateManagerToken(service.id);
        }
      } catch (e) {
        print(e);
      }

      var user = ManagerUser(event.email, event.password, identifiers);
      _managementRepo.saveManagerUser(user);

      yield ManagerLoggedIn(user);
    } else if (event is LogoutManager) {
      yield LoadingSMData();
      _managementRepo.logout();
      yield SMWaitingForLogin();
    } else if (event is InitiateManagerLogin) {
      print('ran initiation');
      var user = _getUserIfLoggedIn();
      var managerUser = await _managementRepo.readManagerUser();
      if (managerUser != null && user == null) {
        dispatch(ShopManagerLogin(managerUser.email, managerUser.password));
      }
    }
  }

  ManagerUser _getUserIfLoggedIn() {
    if (currentState is ManagerLoggedIn) {
      return (currentState as ManagerLoggedIn).user;
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
