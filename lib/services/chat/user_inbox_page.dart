import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/services/chat/inbox_widgets.dart';

import 'inbox_manager.dart';

class UserInboxPage extends StatefulWidget {
  @override
  _UserInboxPageState createState() => _UserInboxPageState();
}

class _UserInboxPageState extends State<UserInboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'پیامهای شما',
      ),
      body: Container(
        child: InboxWidget(Provider.of<InboxManager>(context).userInbox),
      ),
    );
  }
}
