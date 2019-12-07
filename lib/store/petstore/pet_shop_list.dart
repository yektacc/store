/*
import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/home/home_page.dart';
import 'package:store/store/petstore/pet_shop_page.dart';

import 'model.dart';

class PetShopItem extends StatefulWidget {
  final PetShop petShop;

  const PetShopItem(this.petShop, {Key key}) : super(key: key);

  @override
  _PetShopItemState createState() => _PetShopItemState();
}

class _PetShopItemState extends State<PetShopItem> {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: Spaces.listCardInsets,
        height: 40,
        width: 125,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PetShopPage(widget.petShop)));
          },
          child: new Card(
            child: Column(
              children: <Widget>[
                Container(
                  height: 84,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                        width: 117,
                        height: 80,
                        child: Hero(
                          child: Icon(
                            Icons.store,
                            size: 65,
                            color: AppColors.grey[300],
                          ),
                          tag: widget.petShop.id,
                        ),
                      ),
                      widget.petShop.hasDiscount
                          ? new Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.main_color,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(6),
                                        topLeft: Radius.circular(3))),
                                height: 22,
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.local_offer,
                                        color: Colors.grey[100],
                                        size: 15,
                                      ),
                                      Text(
                                        " 20% ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Divider(),
                new Container(
                  child: Column(
                    children: <Widget>[
                      Align(
                        child: Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Text(
                            widget.petShop.name,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 11),
                          ),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                ),
                new Expanded(
                  child: new Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(3),
                                bottomLeft: Radius.circular(3))),
                        height: 24,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.lightGreen,
                              size: 18,
                            ),
                            Text(
                              "  نزدیک به شما  ",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 10),
                            )
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class PetShopList extends StatefulWidget {
  final String title;
  final List<PetShop> petShops;

  PetShopList(this.title, this.petShops);

  @override
  _PetShopListState createState() => _PetShopListState();
}

class _PetShopListState extends State<PetShopList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          padding: EdgeInsets.only(right: 10),
          child: Container(
            height: 56,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                  padding: EdgeInsets.only(top: 7, left: 12, right: 12),
                  height: 38,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
          ),
        ),
        Container(
          height: 175,
          padding: Spaces.listInsets,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: widget.petShops.map((ps) => PetShopItem(ps)).toList(),
          ),
        )
      ],
    );
  }
}
*/
