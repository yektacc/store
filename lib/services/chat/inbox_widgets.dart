import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/services/chat/chat_bloc.dart';
import 'package:store/services/chat/chat_event_state.dart';
import 'package:store/services/chat/chat_page.dart';
import 'package:store/services/chat/inbox_bloc.dart';
import 'package:store/services/chat/inbox_event_state.dart';

class InboxWidget extends StatefulWidget {
  final InboxBloc _inboxBloc;

  InboxWidget(this._inboxBloc);

  @override
  _InboxWidgetState createState() => _InboxWidgetState();
}

class _InboxWidgetState extends State<InboxWidget> {
  @override
  Widget build(BuildContext context) {
    widget._inboxBloc.dispatch(UpdateInbox());

    return BlocBuilder(
      bloc: widget._inboxBloc,
      builder: (context, state) {
        print('inbox state: ' + state.toString());

        if (state is InboxLoading) {
          return LoadingIndicator();
        } else if (state is InboxLoaded) {
          print('inbox loaded: ${state.inbox}');

          print('state is inbox loaded');

          if (state.inbox.isEmpty) {
            return Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.inbox,
                      size: 140,
                      color: Colors.grey[200],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text('شما پیامی ندارید'),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Column(
              children:
                  state.inbox.map((inbox) => ChatListItem(inbox)).toList(),
            );
          }
        } else {
          return Center(
            child: Text('error'),
          );
        }
      },
    );
  }
}

class ChatListItem extends StatelessWidget {
  final ChatBloc _bloc;

  ChatListItem(this._bloc);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        print('CHAT BLOC: $_bloc CHAT STATE: $state');
        if (state is ChatLoaded) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ChatPage(_bloc, state.otherInfo.title)));
            },
            child: Card(
                margin: EdgeInsets.only(left: 10, top: 8),
                elevation: 5,
                color: Colors.grey[200],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          height: 56,
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              state.otherInfo.title,
                              style: TextStyle(color: Colors.blueGrey[800]),
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10, left: 14),
                      child: state.chat.hasNew
                          ? Icon(
                              Icons.new_releases,
                              color: Colors.yellow[700],
                            )
                          : Container(),
                    ),
                  ],
                )),
          );
        } else if (state is ChatLoading) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }
}
