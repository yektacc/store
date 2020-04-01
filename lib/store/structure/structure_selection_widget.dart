import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/store/structure/model.dart';
import 'package:store/store/structure/repository.dart';

class StructureSelectionRow extends StatefulWidget {
  final Function(Identifier) onChange;
  BehaviorSubject<bool> required = BehaviorSubject.seeded(false);
  bool validate;
  Identifier currentCat;
  Identifier currentPet;
  Identifier currentSubCat;

  StructureSelectionRow(this.onChange, {this.validate = false, this.required}) {
    assert(!validate || required != null);
  }

  @override
  _StructureSelectionRowState createState() => _StructureSelectionRowState();
}

class _StructureSelectionRowState extends State<StructureSelectionRow> {
  @override
  Widget build(BuildContext context) {
    var showError = false;

    return StreamBuilder<bool>(
      stream: widget.required,
      builder: (context, snapshot) {
        showError = snapshot.data != null &&
            snapshot.data &&
            widget.currentSubCat == null;
        return Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(color: Colors.grey[300])),
                    height: 60,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    child: DropdownButton<Identifier>(
                      iconEnabledColor: Colors.red,
                      itemHeight: 60,
                      underline: Container(),
                      isExpanded: true,
                      hint: Text("نوع حیوان"),
                      value: widget.currentPet,
                      elevation: 16,
                      style: TextStyle(color: Colors.grey[900], fontSize: 14),
                      onChanged: (Identifier newValue) {
                        setState(() {
                          widget.currentPet = newValue;
                          widget.currentCat = null;
                          widget.currentSubCat = null;
                          widget.onChange(widget.currentPet);
                        });
                      },
                      items: (Provider.of<StructureRepository>(context).fetch())
                          .map<DropdownMenuItem<Identifier>>(
                              (Identifier value) {
                        return DropdownMenuItem<Identifier>(
                          value: value,
                          child: Text(value == null ? "حیوان" : value.name),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                new Container(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          border: Border.all(color: Colors.grey[300])),
                      height: 60,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                      child: new DropdownButton<Identifier>(
                        itemHeight: 60,
                        underline: Container(),
                        icon: Icon(Icons.category),
                        isExpanded: true,
                        hint: Text("دسته"),
                        value: widget.currentCat,
                        elevation: 16,
                        style: TextStyle(color: Colors.grey[900], fontSize: 14),
                        onChanged: (Identifier newValue) {
                          setState(() {
                            widget.currentCat = newValue;
                            widget.currentSubCat = null;
                            widget.onChange(widget.currentCat);
                          });
                        },
                        items: widget.currentPet == null
                            ? []
                            : (widget.currentPet as StructPet)
                                .categories
                                .map<DropdownMenuItem<Identifier>>(
                                    (Identifier value) {
                                return DropdownMenuItem<Identifier>(
                                  value: value,
                                  child: Text(value == null
                                      ? "دسته"
                                      : (value as StructCategory).nameFA),
                                );
                              }).toList(),
                      )),
                ),
                new Container(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          border: Border.all(color: Colors.grey[300])),
                      height: 60,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                      child: new DropdownButton<Identifier>(
                        iconEnabledColor: Colors.red,
                        itemHeight: 60,
                        underline: Container(),
                        icon: Icon(Icons.category),
                        isExpanded: true,
                        hint: Text("زیردسته"),
                        value: widget.currentSubCat,
                        elevation: 16,
                        style: TextStyle(color: Colors.grey[900], fontSize: 14),
                        onChanged: (Identifier newValue) {
                          setState(() {
                            widget.currentSubCat = newValue;
                            widget.onChange(widget.currentSubCat);
                          });
                        },
                        items: widget.currentCat == null
                            ? []
                            : (widget.currentCat as StructCategory)
                                .subCategories
                                .map<DropdownMenuItem<Identifier>>(
                                    (Identifier value) {
                                return DropdownMenuItem<Identifier>(
                                  value: value,
                                  child: Text(value == null
                                      ? "زیردسته"
                                      : (value as StructSubCategory).nameFA),
                                );
                              }).toList(),
                      )),
                )
              ],
            ),
            showError
                ? Container(
                    height: 40,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      "لطفا نوع حیوان، دسته و زیردسته را انتخاب کنید",
                      style: TextStyle(fontSize: 13, color: Colors.red[700]),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
