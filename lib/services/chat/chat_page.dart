import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/services/chat/chat_bloc.dart';
import 'package:store/services/chat/model.dart';

import 'chat_event_state.dart';

class ChatPage extends StatefulWidget {
  final ChatBloc _bloc;
  final String title;

  ChatPage(this._bloc, this.title);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
//  String message = '';
  final TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 16),),),
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
                    Helpers.errorToast();
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: IconButton(
                        onPressed: () {
                          widget._bloc
                              .dispatch(SendMessage(Message(message.text, 1)));
                          message.text = '';
                        },
                        icon: Icon(
                          Icons.send,
                          color: AppColors.main_color,
                          size: 20,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'پیام شما',
                        ),
                        textAlign: TextAlign.right,
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(4),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
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
