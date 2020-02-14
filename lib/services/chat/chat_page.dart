import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/services/chat/chat_bloc.dart';
import 'package:store/services/chat/model.dart';

import 'chat_event_state.dart';

class ChatPage extends StatefulWidget {
  final ChatBloc _bloc;

//  final SenderType _senderType;
  final String title;

  ChatPage(this._bloc, this.title /*, this._senderType*/);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<SimpleMessage> loadedMessages;
  ScrollController _scrollController =
  new ScrollController(initialScrollOffset: 0.0);
  final TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: screenHeight - 135,
              child: BlocBuilder<ChatBloc, ChatState>(
                bloc: widget._bloc,
                builder: (context, state) {
                  if (state is ChatLoaded) {
                    loadedMessages = state.chat.messages;

                    widget._bloc.dispatch(SeenChat(state.chat));

                    return _buildMessageList();
                  } else if (loadedMessages != null) {
                    if (state is FailedLoadingChat) {
                      Helpers.errorToast();
                      return Container();
                    }

                    return _buildMessageList();
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
                          widget._bloc.dispatch(
                              SendMessage(SimpleMessage(message.text, true)));
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

  Widget _buildMessageList() {
//    _scrollController.animateTo(0.0, duration: Duration(milliseconds: 200),curve: );
    var listView = ListView(
//      reverse: true,
      controller: _scrollController,
      children: loadedMessages
          .map((msg) => MessageTextWidget(msg.text, msg.sentByMe))
          .toList(),
    );
    return listView;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget._bloc.dispatch(UpdateChat());
  }
}

class MessageTextWidget extends StatelessWidget {
  final String text;
  final bool sender;

  MessageTextWidget(this.text, this.sender);

  @override
  Widget build(BuildContext context) {
    print(text + "  " + sender.toString());

    return Row(
      mainAxisAlignment:
      sender ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
              color: sender ? Colors.blue[50] : Colors.green[50],
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
