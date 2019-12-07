/*
import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/products/product/product.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback onDismissPressed;
  final VoidCallback onShowPressed;
  bool isShown = false;

  SearchPage(this.onDismissPressed, this.onShowPressed);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {



  AppBar _buildAppBar() {
    var _focusNode = new FocusNode();
    var _textField = new TextField(
      onChanged: (newText) {

      },
*/
/*
      focusNode: _focusNode,
*//*

      */
/*onTap: () {
        if (!widget.isShown) {
          widget.onShowPressed();
          widget.isShown = true;
          setState(() {});
        }
      },*//*

      decoration: InputDecoration(
          focusColor: AppColors.main_color,
          hintText: "جستجو ...",
          hintStyle: TextStyle(fontSize: 13)),
    );

    return AppBar(
      backgroundColor: Colors.grey[200],
      leading: IconButton(
        padding: EdgeInsets.only(right: 14),
        icon: widget.isShown
            ? Icon(
                Icons.clear,
                color: Colors.black54,
              )
            : Icon(
                Icons.search,
                color: AppColors.main_color,
              ),
        onPressed: () {
          print(_textField.controller.text);
        */
/*  if (widget.isShown) {
            setState(() {
              widget.onDismissPressed();
              widget.isShown = false;
            });
          } else {
            setState(() {
              widget.onShowPressed();
              widget.isShown = true;
            });
          }*//*

        },
      ),
      title: Container(
        height: 45,
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(30)),
        child: _textField,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: Colors.grey[100],
      ),
    );
  }
}
*/
