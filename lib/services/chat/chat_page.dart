import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/services/chat/chat_bloc.dart';
import 'package:store/services/chat/model.dart';

import 'chat_event_state.dart';

class ChatPage extends StatefulWidget {
  final ChatBloc _bloc;

  ChatPage(this._bloc);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String message = '';

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: screenHeight - 135,
              child: BlocBuilder<ChatBloc, ChatState>(
                bloc: widget._bloc,
                builder: (context, state) {
                  if (state is MessagesLoading) {
                    return Center(
                      child: LoadingIndicator(),
                    );
                  } else if (state is MessagesLoaded) {
                    return ListView(
                      reverse: true,
                      children: state.messages
                          .map((msg) => MessageTextWidget(msg.text, true))
                          .toList(),
                    );
                  } else if (state is ChatsLoadingFailed) {
                    Helpers.showDefaultErr();
                    return Center(
                      child: Text('err'),
                    );
                  } else {
                    return Container(
                      height: 20,
                      width: 20,
                      color: Colors.red,
                    );
                  }
                },
              ),
            ),
            Container(
                height: 55,
                color: Colors.grey[100],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (newText) {
                          message = newText;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'پیام شما',
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          widget._bloc
                              .dispatch(SendMessage(Message(message, 1)));
                        },
                        icon: Icon(Icons.send),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class MessageTextWidget extends StatelessWidget {
  final String text;
  final bool sender;

  MessageTextWidget(this.text, this.sender);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(3))),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          alignment: Alignment.centerRight,
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        )
      ],
    );
  }
}
