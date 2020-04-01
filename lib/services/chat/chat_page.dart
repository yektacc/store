import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/widgets/app_widgets.dart';
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
      appBar: CustomAppBar(
        titleText: widget.title,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/chat_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
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
                    return Container();
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
                          widget._bloc.dispatch(SendMessage(SimpleMessage(
                              message.text,
                              true,
                              false,
                              DateTime.now().toString())));
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
    List<Widget> items = [];
    SimpleMessage prevMsg;

    loadedMessages.forEach((msg) {
      if (prevMsg == null || prevMsg.day != msg.day) {
        items.add(_buildDayLabel(msg.day, msg.month));
      }

      items.add(MessageTextWidget(msg));
      prevMsg = msg;
    });

    print('items:' + items.toString());

    var listView = ListView(
      reverse: true,
      controller: _scrollController,
      children: items.reversed.toList(),
    );
    return listView;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget._bloc.dispatch(UpdateChat());
  }

  Widget _buildDayLabel(int day, int month) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      color: Colors.grey[100],
      child: Text(
        day.toString() + '/' + month.toString(),
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class MessageTextWidget extends StatelessWidget {
  final SimpleMessage message;

  final double timeAreaHeight = 18;

  MessageTextWidget(this.message);

  @override
  Widget build(BuildContext context) {
    print(message.text + "  " + message.sentByMe.toString());

    return Row(
      mainAxisAlignment:
      message.sentByMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
              color: message.sentByMe ? Colors.blue[50] : Colors.green[50],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(4),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          padding: EdgeInsets.only(
            top: 8,
            left: 10,
          ),
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  message.text,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                height: timeAreaHeight,
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  children: <Widget>[
                    message.sentByMe && message.seen
                        ? Padding(
                      padding: EdgeInsets.only(right: 3),
                      child: Icon(
                        Icons.check,
                        size: 12,
                      ),
                    )
                        : Container(),
                    message.sentByMe
                        ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 3),
                      color: Colors.white,
                      height: 10,
                      width: 1,
                    )
                        : Container(),
                    Container(
                      margin: EdgeInsets.only(right: 6),
                      height: timeAreaHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            message.time,
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
