import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/login_register/login/login_page.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/products/comments/comments_repository.dart';

import 'new_comment.dart';

class CommentsPage extends StatefulWidget {
  final int saleItemId;

  CommentsPage(this.saleItemId);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  CommentsRepository _commentsRepository;

  @override
  Widget build(BuildContext context) {
    if (_commentsRepository == null) {
      _commentsRepository = Provider.of<CommentsRepository>(context);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.second_color,
        onPressed: () {
          var currentLoginState =
              Provider.of<LoginStatusBloc>(context).currentState;

          if (currentLoginState is IsLoggedIn) {
            var user = currentLoginState.user;
            showDialog(
                context: context,
                builder: (context) =>
                    NewCommentWgt(widget.saleItemId, '',(comment, loading) async {
                      loading.add(true);
                      var res = await _commentsRepository.sendComment(
                          widget.saleItemId, comment, user.sessionId);
                      loading.add(false);
                      if (res) {
                        Navigator.pop(context);
                        setState(() {});
                        Helpers.showToast('نظر شما ارسال شد.');
                      } else {
                        Helpers.errorToast();
                      }
                    }));
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage()));
          }
        },
        child: Center(
          child: Icon(Icons.add_comment),
        ),
      ),
      appBar: AppBar(
        title: Text('نظرات کاربران'),
      ),
      body: FutureBuilder<List<Comment>>(
        future: _commentsRepository.fetch(widget.saleItemId),
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.data != null) {
            if (snapshot.data.isEmpty) {
              return Center(
                child: Text('برای این محصول نظری ثبت نشده است'),
              );
            } else {
              return ListView(
                  children: snapshot.data.map(_buildCommentItem).toList());
            }
          } else {
            return Center(
              child: LoadingIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Card(
      margin: EdgeInsets.only(top: 9, right: 7, left: 7),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4))),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8, left: 8),
                  child: Icon(
                    Icons.person,
                    color: AppColors.main_color,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(comment.username),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(comment.text),
          )
        ],
      ),
    );
  }
}
