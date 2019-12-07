import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:rxdart/rxdart.dart';

class NewCommentWgt extends StatefulWidget {
  final int saleItemId;
  final Function(String comment, BehaviorSubject loading) onSubmit;
  final String initialName;

  NewCommentWgt(this.saleItemId, this.initialName, this.onSubmit);

  @override
  _NewCommentWgtState createState() => _NewCommentWgtState();
}

class _NewCommentWgtState extends State<NewCommentWgt> {
  final TextEditingController commentCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final BehaviorSubject<bool> loading = BehaviorSubject.seeded(false);

  @override
  void dispose() {
    loading.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (nameCtrl.text.isEmpty) {
      nameCtrl.text = widget.initialName;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ثبت نظر',
          style: TextStyle(color: AppColors.main_color,fontSize: 16),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.main_color,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: StreamBuilder<bool>(
          stream: loading,
          builder: (context, snapshot) {
            if (snapshot != null && snapshot.data != null && !snapshot.data) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      /*borderRadius: BorderRadius.circular(20)*/
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                          hintText: 'نام',
                          border: InputBorder.none,
                          icon: Icon(Icons.person),
                          hintStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      /*borderRadius: BorderRadius.circular(20)*/
                    ),
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      minLines: 5,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      controller: commentCtrl,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.comment),
                          hintText: 'نظر شما...',
                          hintStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      widget.onSubmit(commentCtrl.text, loading);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColors.main_color,
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.send,
                                    size: 18,
                                    textDirection: TextDirection.ltr,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 9),
                                  child: Text(
                                    'ثبت',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                  )
                ],
              );
            } else {
              return LoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}
