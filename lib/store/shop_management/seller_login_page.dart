import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/shop_management/seller_repository.dart';
import 'package:store/store/shop_management/seller_list_page.dart';
import 'package:provider/provider.dart';

class SellerLoginPage extends StatefulWidget {
  @override
  _SellerLoginPageState createState() => _SellerLoginPageState();
}

class _SellerLoginPageState extends State<SellerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  ShopRepository _sellerRepo;
  bool error = false;

  /*final*/ String phoneController = /*TextEditingController()*/ '';
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_sellerRepo == null) {
      _sellerRepo = Provider.of<ShopRepository>(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ورود فروشندگان',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: new Container(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: new Center(
            child: new Container(
              color: Colors.grey[300],
              child: Container(
                child: new Form(
                  key: _formKey,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          color: Colors.white,
                          child: TextFormField(
                            onChanged: (newText) {
                              phoneController = newText;
                            },
/*
                            controller: phoneController,
*/
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  size: 22,
                                ),
                                hintStyle: TextStyle(fontSize: 13),
                                hintText: "نام کاربری"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'نام کاربری وارد نشده است';
                              }
                              return null;
                            },
                          ),
                          padding:
                              EdgeInsets.only(left: 50, right: 20, top: 14)),
                      Container(
                        color: Colors.white,
                        child: TextFormField(
                          obscureText: true,
                          controller: passController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              size: 22,
                            ),
                            hintText: "رمز عبور",
                            hintStyle: TextStyle(fontSize: 13),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'رمز عبور وارد نشده است';
                            }
                            return null;
                          },
                        ),
                        padding: EdgeInsets.only(left: 50, right: 20, top: 12),
                      ),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 18.0, bottom: 18),
                        child: Center(
                          child: FlatButton(
                            textColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _sellerRepo
                                    .loginSeller(phoneController,
                                        passController.text)
                                    .then((List<Shop> response) {
                                  if (response.isEmpty) {
                                    setState(() {
                                      error = true;
                                      phoneController = '';
                                      passController.text = '';
                                    });
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SellersListPage(response)));
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: 34,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.main_color,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Text(
                                'ورود',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 70),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 25),
                        child: Center(
                            child: error
                                ? Text(
                                    "نام کاربری یا کلمه عبور صحیح نمی باشد!",
                                    style: TextStyle(
                                        color: AppColors.main_color,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Container()),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
