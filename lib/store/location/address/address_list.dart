import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/location/address/edit_address_page.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';

import 'address_bloc.dart';
import 'address_bloc_event.dart';
import 'model.dart';

class AddressSelection extends StatefulWidget {
  final List<Address> _addresses;
  Address selected;

  AddressSelection(this._addresses);

  @override
  _AddressSelectionState createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: ListView(
          children: widget._addresses
              .map((address) => AddressItem(address, () {
                    widget.selected = address;
                    setState(() {});
                  },
                      widget.selected != null &&
                          widget.selected.id == address.id))
              .toList(),
        ));
  }
}

class AddressItem extends StatefulWidget {
  final Address _address;
  final bool isSelected;
  final VoidCallback _onTap;

  AddressItem(this._address, this._onTap, this.isSelected);

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget._onTap,
      child: BlocBuilder(
        bloc: Provider.of<LoginStatusBloc>(context),
        builder: (context, LoginStatusState loginState) {
          if (loginState is IsLoggedIn) {
            return new Container(
              color: widget.isSelected ? Colors.grey[300] : Colors.grey[50],
              margin: EdgeInsets.only(bottom: 1),
              padding: EdgeInsets.only(bottom: 7),
              height: 88,
              child: Row(
                children: <Widget>[
                  Center(child: Text(
                    '    انتخاب  ', style: TextStyle(fontSize: 11),),),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: widget.isSelected
                                        ? AppColors.main_color
                                        : Colors.grey[500],
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      widget._address.address,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: widget.isSelected
                                              ? Colors.black87
                                              : Colors.black45),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: widget.isSelected
                                          ? AppColors.main_color
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(7)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 7),
                                  margin: EdgeInsets.only(right: 8),
                                  child: Text(
                                    widget._address.fullName,
                                    style: TextStyle(
                                        color: widget.isSelected
                                            ? Colors.white
                                            : Colors.black54,
                                        fontSize: 10),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(),
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: widget.isSelected
                                  ? AppColors.main_color
                                  : Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              if (widget._address.editable) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        AddressAddEditPage(
                                          true,
                                          address: widget._address,
                                          sessionId: int.parse(
                                              loginState.user.sessionId),
                                        )));
                              } else {
                                Helpers.showToast(
                                    'آدرس مورد نظر به دلیل استفاده قبلی غیر قابل اصلاح می باشد. درصورت نیاز آدرس جدید تعریف کنید.');
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: widget.isSelected
                                  ? AppColors.main_color
                                  : Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              _showDeleteConfirmDialog(() {
                                Provider.of<AddressBloc>(context).dispatch(
                                    RemoveAddress(widget._address.id,
                                        int.parse(loginState.user.sessionId)));
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              child: Text("لطفا وارد شوید"),
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmDialog(VoidCallback onConfirm) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "آیا می خواهید آدرس را حذف کنید؟",
            style: TextStyle(fontSize: 13),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("بله"),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("خیر"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
