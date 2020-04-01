import 'package:store/data_layer/netclient.dart';
import 'package:store/services/chat/inbox_bloc.dart';
import 'package:store/services/chat/inbox_event_state.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/management/management_login_bloc.dart';
import 'package:store/store/management/management_login_event_state.dart';
import 'package:store/store/management/model.dart';

import 'model.dart';

class InboxManager {
  InboxBloc managerInbox;
  InboxBloc userInbox;
  final LoginStatusBloc _loginStatusBloc;
  final ManagerLoginBloc _managerLoginBloc;
  final Net _net;

  InboxManager(this._loginStatusBloc, this._managerLoginBloc, this._net) {
    _loginStatusBloc.state.listen((status) {
      if (status is IsLoggedIn) {
        if (userInbox == null) {
          _setUserInbox(InboxBloc(ClientChatUser(status.user.appUserId), _net));
        }
      }
    });

    _managerLoginBloc.state.listen((state) {
      if (state is ManagerLoggedIn) {
        try {
          var service = state.user.centerIdentifiers
              .firstWhere((id) => id is ServiceIdentifier);
          if (service != null) {
            _setManagerInbox(
                InboxBloc(CenterChatUser(service.id.toString()), _net));
          }
        } catch (e) {
          print(e);
        }
      }
    });

//    new Timer.periodic(Duration(seconds: 7), (Timer t) {
//      if (managerInbox != null) {
//        managerInbox.dispatch(UpdateInbox());
//      }
//
//      if (userInbox != null) {
//        userInbox.dispatch(UpdateInbox());
//      }
//    });
  }

  _setUserInbox(InboxBloc inbox) {
    userInbox = inbox;
  }

  _setManagerInbox(InboxBloc inbox) {
    managerInbox = inbox;
  }

  syncInboxes() {
    if (managerInbox != null) {
      managerInbox.dispatch(UpdateInbox());
    }

    if (userInbox != null) {
      userInbox.dispatch(UpdateInbox());
    }
  }
}
