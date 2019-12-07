import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/products/product/products_bloc.dart';
import 'package:store/store/products/search/search_delegate.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'filter_page.dart';

enum FilterTabState { /*FILTER,*/ SORT, HIDDEN }

class FilterSortHeader extends StatelessWidget implements PreferredSizeWidget {
/*
  final VoidCallback onShowFilterTap;
*/
  final VoidCallback onShowSortTap;
  final VoidCallback onHideTap;
  final BehaviorSubject<FilterTabState> isShown;

  FilterSortHeader(
    /*
    this.onShowFilterTap,
*/
    this.onShowSortTap,
    this.onHideTap,
    this.isShown,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new StreamBuilder<FilterTabState>(
        stream: isShown,
        builder: (context, AsyncSnapshot<FilterTabState> snapshot) {
          if (snapshot.data == FilterTabState.HIDDEN) {
            return new Container(
              color: Colors.grey[100],
              child: Row(
                children: <Widget>[
                  Container(
                    width: 55,
                    child: Card(
                      color: Colors.grey[500],
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Container(
                        width: 45,
                        child: Center(
                          child: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: CustomSearchDelegate(
                                      Provider.of<ProductsBloc>(context)
                                          .currentIdentifier),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: onShowSortTap,
                      child: new Container(
                        alignment: Alignment.centerLeft,
                        child: new Stack(
                          alignment: Alignment.centerLeft,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: 50, right: 40, top: 3, bottom: 4),
                              decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                  child: Text(
                                "فیلتر / مرتب سازی",
                                style: TextStyle(color: AppColors.main_color),
                              )),
                            ),
                            Card(
                              color: AppColors.main_color,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40),
                                      topRight: Radius.circular(40))),
                              margin:
                                  EdgeInsets.only(left: 31, top: 4, bottom: 5),
                              child: Container(
                                width: 45,
                                child: Center(
                                  child: Icon(
                                    Icons.filter_list,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container(
              color: Colors.grey[200],
              child: new Container(
                color: Colors.grey[100],
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 55,
                      child: Card(
                        color: Colors.grey[500],
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        child: Container(
                          width: 45,
                          child: Center(
                            child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  showSearch(
                                    context: context,
                                    delegate: CustomSearchDelegate(
                                        Provider.of<ProductsBloc>(context)
                                            .currentIdentifier),
                                  );
                                }),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: onHideTap,
                        child: new Container(
                          alignment: Alignment.centerLeft,
                          child: new Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 30, right: 40, top: 3, bottom: 4),
                                decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(40),
                                    border:
                                        Border.all(color: Colors.grey[200])),
                                child: Center(
                                    child: Text(
                                  "فیلتر / مرتب سازی",
                                  style: TextStyle(color: AppColors.main_color),
                                )),
                              ),
                              Card(
                                color: Colors.grey[100],
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        bottomLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(40),
                                        topRight: Radius.circular(40))),
                                margin: EdgeInsets.only(
                                    left: 31, top: 4, bottom: 5),
                                child: Container(
                                  width: 45,
                                  child: Center(
                                    child: Icon(
                                      Icons.clear,
                                      color: AppColors.main_color,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 56);
}

class TabItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  TabItem(this.text, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: color),
            ),
          )
        ],
      ),
    );
  }
}

class FilterSortArea extends StatefulWidget {
  final BehaviorSubject<FilterTabState> _isShown;

  FilterSortArea(this._isShown);

  @override
  _FilterSortAreaState createState() => _FilterSortAreaState();
}

class _FilterSortAreaState extends State<FilterSortArea> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget._isShown,
      builder: (context, AsyncSnapshot<FilterTabState> snapshot) {
        print("state: " + snapshot.data.toString());
        return DefaultTabController(
          initialIndex: snapshot.data == FilterTabState.SORT ? 1 : 0,
          length: 2,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: FilterSortHeader(
                /*() {
              widget._isShown.add(FilterTabState.FILTER);
            },*/
                () {
              widget._isShown.add(FilterTabState.SORT);
            }, () {
              widget._isShown.add(FilterTabState.HIDDEN);
            }, widget._isShown),
            body: Container(
              color: Colors.grey[100],
              alignment: Alignment.center,
              child: FilteringDrawer(),
            ),
          ),
        );
      },
    );
  }
}
