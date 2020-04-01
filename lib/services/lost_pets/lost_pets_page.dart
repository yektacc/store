import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/services/lost_pets/lost_pets_event_state.dart';
import 'package:store/store/location/provinces/model.dart';

import 'add_lost_pet_page.dart';
import 'lost_pets_bloc.dart';
import 'lost_pets_repository.dart';
import 'model.dart';

class LostPetsPage extends StatefulWidget {
  static const String routeName = 'lostpetspage';

  final PetRequestType type;

  const LostPetsPage(this.type);

  @override
  _LostPetsPageState createState() => _LostPetsPageState();
}

class _LostPetsPageState extends State<LostPetsPage> {
  LostPetsBloc _lostPetBloc;

  AnimalType currentAnimalType;
  City currentCity;
  Province currentProvince;

  @override
  Widget build(BuildContext context) {
    if (_lostPetBloc == null) {
      _lostPetBloc = Provider.of<LostPetsBloc>(context);
      _lostPetBloc.dispatch(Reset());
      _lostPetBloc.dispatch(FetchLostPets(widget.type));
    }

    String name;

    switch (widget.type) {
      case PetRequestType.LOST_FOUND:
        name = "گمشده / پیدا شده";
        break;
      case PetRequestType.ADOPTION:
        name = "سرپرستی / واگذاری";
        break;
      case PetRequestType.All:
        // TODO: Handle this case.
        break;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.main_color,
        onPressed: () {
          _openFilterBar(context);
        },
        child: Icon(Icons.filter_list),
      ),
      appBar: CustomAppBar(
        titleText: name,
        light: true,
        actions: <Widget>[
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            color: Colors.grey[700],
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.description,
                      size: 22,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FCRequestPage(
                                  widget.type == PetRequestType.ADOPTION)));
                    }),
                Text(
                  "ثبت آگهی   ",
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
      body: Container(
        child: BlocBuilder(
          bloc: _lostPetBloc,
          builder: (context, LostPetsState state) {
            if (state is LostPetsLoaded) {
              var filteredPets = _filter(state.lostPets);

              return ListView.builder(
                  itemCount: filteredPets.length,
                  itemBuilder: (context, index) {
                    return LostPetItemWgt(filteredPets[index]);
                  });
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  List<LostPet> _filter(List<LostPet> allPets) {
    print(
        "current filters: ${currentAnimalType ?? 'null'}  ${currentCity ?? 'null'} ${currentProvince ?? 'null'}");

    List<LostPet> results = allPets;

    if (currentAnimalType != null) {
      results = results
          .where((lp) => lp.animalType.id == currentAnimalType.id)
          .toList();
    }

    if (currentCity != null) {
      results = results.where((lp) => lp.city.id == currentCity.id).toList();
    }

    if (currentProvince != null) {
      results =
          results.where((lp) => lp.province.id == currentProvince.id).toList();
    }

    return results;
  }

  _setFilters(AnimalType animalType, City city, Province province) {
    setState(() {
      currentAnimalType = animalType;
      currentCity = city;
      currentProvince = province;
    });
  }

  _openFilterBar(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return FilterLostAndFound(_setFilters);
        });
  }
}

class FilterLostAndFound extends StatefulWidget {
  final Function(AnimalType _animalType, City city, Province province) filter;

  FilterLostAndFound(this.filter);

  @override
  _FilterLostAndFoundState createState() => _FilterLostAndFoundState();
}

class _FilterLostAndFoundState extends State<FilterLostAndFound> {
  AnimalType currentAnimalType;
  Province currentProvince;
  City currentCity;
  List<AnimalType> allTypes;

  final GlobalKey<FormBuilderState> _filterFormKey =
      GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return new FormBuilder(
        key: _filterFormKey,
        child: new Container(
          color: Colors.grey[300],
          height: 216,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  color: Colors.grey[100],
                  child: ProvinceCitySelectionRow((province, city) {
                    currentProvince = province;
                    currentCity = city;
                  }),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Icon(
                          Icons.pets,
                          color: AppColors.main_color,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: new FutureBuilder(
                            future: Provider.of<LostPetsRepository>(context)
                                .getAnimalTypes(),
                            builder: (context,
                                AsyncSnapshot<List<AnimalType>> snapshot) {
                              List<AnimalType> types = [];

                              if (allTypes != null && allTypes.isNotEmpty) {
                                types = allTypes;
                              } else if (snapshot.data != null &&
                                  snapshot.data.isNotEmpty) {
                                types = snapshot.data;
                                allTypes = types;
                              }

                              return new FormBuilderDropdown(
                                attribute: "type",
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: true),
                                // initialValue: 'Male',
                                hint: Center(
                                  child: Text(
                                    'نوع حیوان: ',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[800]),
                                  ),
                                ),
                                validators: [FormBuilderValidators.required()],
                                onChanged: (type) {
                                  currentAnimalType = (type as AnimalType);
                                },
                                items: types
                                    .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Center(
                                          child: Text(
                                            "${type.title}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: AppColors.main_color),
                                          ),
                                        )))
                                    .toList(),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: Card(
                      color: AppColors.main_color,
                      elevation: 7,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        child: Text(
                          "اعمال فیلترها",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      widget.filter(
                          currentAnimalType, currentCity, currentProvince);
                      Navigator.of(context).pop();
                    },
                  ))
            ],
          ),
        ));
  }
}

class LostPetItemWgt extends StatefulWidget {
  final LostPet _item;

  LostPetItemWgt(this._item);

  @override
  _LostPetItemWgtState createState() => _LostPetItemWgtState();
}

class _LostPetItemWgtState extends State<LostPetItemWgt> {
  PersianDateTime persianDate;

  @override
  Widget build(BuildContext context) {
    persianDate = PersianDateTime.fromGregorian(
        gregorianDateTime: widget._item.lostDate.split(' ')[0]);

    return Card(
      elevation: 6,
      child: Container(
        height: 180,
        width: double.infinity,
        child: new Row(
          children: <Widget>[
            new Container(
              width: 110,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.only(topRight: Radius.circular(4)),
                          color: widget._item.reqType.id == 2
                              ? AppColors.main_color
                              : AppColors.main_color,
                          /*borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(19))*/
                        ),
                        child: Center(
                          child: Text(
                            widget._item.reqType.name,
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                  Container(
                    color: Colors.grey[200],
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.only(top: 6, bottom: 6),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.pets,
                          size: 18,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 18),
                            child: Text(widget._item.animalType.title),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Icon(
                      Icons.pets,
                      color: Colors.grey[100],
                      size: 90,
                    ),
                  )
                ],
              ),
            ),
            new Expanded(
              child: Container(
                color: Colors.grey[50],
                padding: EdgeInsets.only(top: 7),
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                child: Text(
                                  "نام :  ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13),
                                ),
                                padding: EdgeInsets.only(right: 8),
                              ),
                              Text(
                                widget._item.name == null ||
                                        widget._item.name == "null"
                                    ? "نامشخص"
                                    : widget._item.name,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Text(
                                "جنسیت :  ",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13),
                              ),
                              Text(
                                widget._item.gender == null ||
                                        widget._item.gender == -1
                                    ? "نامشخص"
                                    : widget._item.gender == 1 ? 'نر' : 'ماده',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 30,
                      padding: EdgeInsets.only(right: 8),
                      child: widget._item.description == null ||
                              widget._item.description == 'null'
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                widget._item.description,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[100],
                        padding: EdgeInsets.only(right: 8),
                        alignment: Alignment.bottomRight,
                        child: Column(
                          children: <Widget>[
                            widget._item.location == null ||
                                    widget._item.location == 'null'
                                ? Container()
                                : Expanded(
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: AppColors.main_color,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Text(
                                                widget._item.province.name +
                                                    ", " +
                                                    widget._item.city.name),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            widget._item.location == null ||
                                    widget._item.location == 'null'
                                ? Container()
                                : Expanded(
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Text(widget._item.location),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            widget._item.lostDate == null ||
                                    widget._item.lostDate == 'null'
                                ? Container()
                                : Expanded(
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            size: 16,
                                            color: AppColors.main_color,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Text(persianDate
                                                .toJalaali()
                                                .toString()),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LostPetItem {
  final String title;
  final String img;

  LostPetItem(this.title, this.img);
}
