import 'package:flutter/material.dart';
import 'package:store/store/location/provinces/model.dart';

import 'model.dart';

class AdoptionsPage extends StatefulWidget {
  static const String routeName = 'adoptionpage';

  @override
  _AdoptionsPageState createState() => _AdoptionsPageState();
}

class _AdoptionsPageState extends State<AdoptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("سرپرستی"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            AdoptionItemWgt(AdoptionPet("", City("a", 0, 0, 0))),
            AdoptionItemWgt(AdoptionPet( "", City("b", 0, 0, 0))),
            AdoptionItemWgt(AdoptionPet("", City("d", 0, 0, 0))),
            AdoptionItemWgt(AdoptionPet("", City("d", 0, 0, 0))),
          ],
        ),
      ),
    );
  }
}

class AdoptionItemWgt extends StatefulWidget {
  final AdoptionPet _item;

  AdoptionItemWgt(this._item);

  @override
  _AdoptionItemWgtState createState() => _AdoptionItemWgtState();
}

class _AdoptionItemWgtState extends State<AdoptionItemWgt> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 110,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Container(
              width: 110,
              child: Icon(Icons.store),
            ),
            Expanded(
              child: Center(
                child: Text(widget._item.city.name),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
class AdoptionItem {
  final String title;
  final String img;
  final String imgUrl;

  AdoptionItem(this.title, this.img, this.imgUrl);
}
*/
