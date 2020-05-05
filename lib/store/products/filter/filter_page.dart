import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/products/brands/brands_bloc.dart';
import 'package:store/store/products/brands/brands_event_state.dart';

import 'filter.dart';
import 'filtered_products_bloc.dart';
import 'filtered_products_bloc_event.dart';

class SortSelection extends StatefulWidget {
  final BehaviorSubject<SortingType> currentSort;

  SortSelection(this.currentSort);

  @override
  _SortSelectionState createState() => _SortSelectionState();
}

class _SortSelectionState extends State<SortSelection> {

  final List<String> sortingTitles = [
    "قیمت (صعودی)",
    "قیمت (نزولی)",
    "امتیاز",
    "فاصله از شما",
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SortingType>(
      stream: widget.currentSort,
      builder: (context, AsyncSnapshot<SortingType> snapshot) {
        return Container(
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: _buildSortingItem(
                          sortingTitles[0],
                          SortingType.BY_PRICE_ASC,
                          snapshot.data == SortingType.BY_PRICE_ASC
                              ? true
                              : false),
                    ),
                    Expanded(
                      child: _buildSortingItem(
                          sortingTitles[1],
                          SortingType.BY_PRICE_DES,
                          snapshot.data == SortingType.BY_PRICE_DES
                              ? true
                              : false),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: _buildSortingItem(
                          sortingTitles[2],
                          SortingType.BY_RATE,
                          snapshot.data == SortingType.BY_RATE ? true : false),
                    ),
                    Expanded(
                      child: _buildSortingItem(
                          sortingTitles[3],
                          SortingType.BY_LOCATION,
                          snapshot.data == SortingType.BY_LOCATION
                              ? true
                              : false),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortingItem(String title, SortingType type, bool selected) {
    return GestureDetector(
      onTap: () {
        widget.currentSort.add(type);
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[100],
              border:
              selected ? Border.all(color: AppColors.main_color) : null),
          child: Row(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.done,
                  size: 19,
                  color: selected ? AppColors.main_color : Colors.grey[400],
                ),
                margin: EdgeInsets.only(right: 10),
              ),
              new Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16),
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 11,
                        color:
                            selected ? AppColors.main_color : Colors.grey[600]),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class PriceRange {
  int min;
  int max;

  PriceRange({this.min, this.max});
}

class FilteringDrawer extends StatefulWidget {
  FilteringDrawer(); //  int _currentPageIndex = 0;

  @override
  _FilteringDrawerState createState() => _FilteringDrawerState();
}

class _FilteringDrawerState extends State<FilteringDrawer> {
  FilteredProductsBloc _filteredProductsBloc;

  /*final BehaviorSubject<FilterData> selectedFiltersStream = BehaviorSubject();
  final BehaviorSubject<FilterData> currentFilters = BehaviorSubject();*/

  final BehaviorSubject<List<String>> selectedBrands =
      BehaviorSubject.seeded([]);

  final BehaviorSubject<SortingType> selectedSort =
      BehaviorSubject.seeded(SortingType.BY_PRICE_DES);

  final BehaviorSubject<RangeValues> selectedRange =
      BehaviorSubject.seeded(RangeValues(0, 200000));

/*
  final BehaviorSubject<int> selectedMaxPrice = BehaviorSubject.seeded(200000);
*/

/*

  final BehaviorSubject<SortingType> currentSort =
  BehaviorSubject.seeded(SortingType.BY_PRICE_DES);
*/

  FilterData currentFilter;

  @override
  Widget build(BuildContext context) {
    if (_filteredProductsBloc == null) {
      _filteredProductsBloc = Provider.of<FilteredProductsBloc>(context);
    }

    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: new Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                /*CategoryArea(),*/
                PriceRangeArea(selectedRange),
                Divider(
                  color: Colors.grey[200],
                ),
                BrandsArea(selectedBrands),
                //sort
                new Container(
                    height: 130,
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.only(right: 6, top: 12, bottom: 4),
                              child: Text(
                                "مرتب سازی بر اساس:",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black54),
                              ),
                            ),
                            Expanded(
                              child: SortSelection(selectedSort),
                            )
                          ],
                        ))),
                Container(
                  child: RaisedButton(
                      color: AppColors.main_color,
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        child: Text(
                          "اعمال فیلتر ها",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        _filteredProductsBloc.dispatch(UpdateFilter(FilterData(
                            brands: selectedBrands.stream.value,
                            minPrice: selectedRange.stream.value != null
                                ? Price(
                                    selectedRange.stream.value.start.toInt().toString())
                                : null,
                            maxPrice: selectedRange.stream.value != null
                                ? Price(
                                    selectedRange.stream.value.end.toInt().toString())
                                : null,
                            sort: selectedSort.stream.value)));
                      }),
                )
              ],
            )));
  }

  @override
  void dispose() {
    super.dispose();
    selectedBrands.close();
    selectedSort.close();
    selectedRange.close();
    /*selectedFiltersStream.close();
    currentFilters.close();*/
  }
}

class BrandsArea extends StatefulWidget {
  final BehaviorSubject<List<String>> selected;

  BrandsArea(this.selected);

  @override
  _BrandsAreaState createState() => _BrandsAreaState();
}

class _BrandsAreaState extends State<BrandsArea> {
  BrandsBloc _brandsBloc;

  @override
  Widget build(BuildContext context) {
    if (_brandsBloc == null) {
      _brandsBloc = Provider.of<BrandsBloc>(context);
      _brandsBloc.dispatch(FetchBrands());
    }

    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          alignment: Alignment.centerRight,
          child: Text(
            "برند:",
            style: TextStyle(color: Colors.grey[700]),
          ),
          padding: EdgeInsets.only(top: 10, right: 6),
        ),
        new BlocBuilder(
          bloc: _brandsBloc,
          builder: (context, BrandsState state) {
            if (state is LoadingBrands) {
              return new Center(
                child: new Center(child: LoadingIndicator()),
              );
            } else if (state is LoadedBrands) {
              return new Container(
                height: 65,
                padding: EdgeInsets.only(top: 6, bottom: 6),
                color: Colors.white,
                child: StreamBuilder<List<String>>(
                  stream: widget.selected,
                  builder:
                      (context, AsyncSnapshot<List<String>> selectedBrands) {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.brands
                          .map((brand) => _brandItem(
                                  brand,
                                  selectedBrands.data != null &&
                                      selectedBrands.data.contains(brand), () {
                                if (selectedBrands.data != null &&
                                    selectedBrands.data.contains(brand)) {
                                  List<String> removedList =
                                      selectedBrands.data;
                                  removedList.remove(brand);
                                  widget.selected.add(removedList);
                                } else {
                                  widget.selected
                                      .add(selectedBrands.data + [brand]);
                                }
                              }))
                          .toList(),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Text("خطا"),
              );
            }
          },
        )
      ],
    );
  }

  Widget _brandItem(String title, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 100,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[100],
              border:
              selected ? Border.all(color: AppColors.main_color) : null),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 11,
                        color: selected
                            ? AppColors.second_color
                            : Colors.grey[600]),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
/*

class CategoryArea extends StatefulWidget {
  @override
  _CategoryAreaState createState() => _CategoryAreaState();
}

class _CategoryAreaState extends State<CategoryArea> {
  StructureBloc _structureBloc;

  StructPet pet;
  StructCategory category;
  StructSubCategory subCategory;

  final GlobalKey<FormBuilderState> _categoryKey =
      GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    if (_structureBloc == null) {
      _structureBloc = Provider.of<StructureBloc>(context);
    }

    var allPets = StructPet("همه ی محصولات", "", -1, []);
    var allCats = StructCategory(-1, " همه", "", [], -1);
    var allSubCats = StructSubCategory(-1, "همه", "", -1, -1);

    return Container(
      padding: EdgeInsets.only(right: 15, left: 15),
      child: new BlocBuilder(
        bloc: _structureBloc,
        builder: (context, StructureState state) {
          if (state is LoadedStructure) {
            return new Container(
                height: 80,
                child: FormBuilder(
                  key: _categoryKey,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new FormBuilderDropdown(
                          onChanged: (_) {
                            if (_categoryKey.currentState.saveAndValidate()) {
                              pet = (_categoryKey.currentState.value['pet']);
                            }
                            setState(() {});
                          },
                          attribute: "pet",
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true),
                          initialValue: allPets,
                          hint: new Center(
                            child: Text(
                              'نوع حیوان: ',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[800]),
                            ),
                          ),
                          validators: [FormBuilderValidators.required()],
                          items: (state.pets + [allPets])
                              .map((pet) => DropdownMenuItem<StructPet>(
                                  value: pet,
                                  child: Center(
                                    child: Text(
                                      "${pet.nameFA}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.main_color),
                                    ),
                                  )))
                              .toList(),
                        ),
                      ),
                      pet != null && pet.id != -1
                          ? new Expanded(
                              child: new FormBuilderDropdown(
                                onChanged: (_) {
                                  if (_categoryKey.currentState
                                      .saveAndValidate()) {
                                    category = (_categoryKey
                                        .currentState.value['category']);
                                    setState(() {});
                                  }
                                },
                                attribute: "category",
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: true),
                                initialValue: allCats,
                                hint: new Center(
                                  child: Text(
                                    'نوع حیوان: ',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey[800]),
                                  ),
                                ),
                                validators: [FormBuilderValidators.required()],
                                items: (pet.categories + [allCats])
                                    .map((category) =>
                                        DropdownMenuItem<StructCategory>(
                                            value: category,
                                            child: Center(
                                              child: Text(
                                                "${category.nameFA}",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color:
                                                        AppColors.main_color),
                                              ),
                                            )))
                                    .toList(),
                              ),
                            )
                          : Container(),
                      category != null && category.id != -1
                          ? new Expanded(
                              child: new FormBuilderDropdown(
                                onChanged: (_) {
                                  if (_categoryKey.currentState
                                      .saveAndValidate()) {
                                    subCategory = (_categoryKey
                                        .currentState.value['subCategory']);
                                    setState(() {});
                                  }
                                },
                                attribute: "subCategory",
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: true),
                                initialValue: allSubCats,
                                hint: new Center(
                                  child: Text(
                                    'نوع حیوان: ',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[800]),
                                  ),
                                ),
                                validators: [FormBuilderValidators.required()],
                                items: (category.subCategories + [allSubCats])
                                    .map((subCat) =>
                                        DropdownMenuItem<StructSubCategory>(
                                            value: subCat,
                                            child: Center(
                                              child: Text(
                                                "${subCat.nameFA}",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color:
                                                        AppColors.main_color),
                                              ),
                                            )))
                                    .toList(),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ));
          } else {
            return new Container(
              height: 60,
              child: LoadingIndicator(),
            );
          }
        },
      ),
    );
  }
}
*/

class PriceRangeArea extends StatefulWidget {
  final BehaviorSubject<RangeValues> priceRange;

/*
  final BehaviorSubject<int> maxPrice;
*/

  PriceRangeArea(this.priceRange /*, this.maxPrice*/);

  @override
  _PriceRangeAreaState createState() => _PriceRangeAreaState();
}

class _PriceRangeAreaState extends State<PriceRangeArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8),
            alignment: Alignment.centerRight,
            width: double.infinity,
            height: 25,
            child: Text(
              "محدوده قیمت",
              style: TextStyle(fontSize: 12, color: AppColors.main_color),
            ),
            color: Colors.white,
            padding: EdgeInsets.only(right: 6),
          ),
          new Expanded(
            child: Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*RangeSlider<int>(
              values: _values,
              onChanged: (RangeValues values) {
                setState(() {
                  _values = values;
                });
              },
            );*/
                  StreamBuilder<RangeValues>(
                    stream: widget.priceRange,
                    builder: (context, snapshot) {
                      if (snapshot != null && snapshot.data != null) {
                        return Row(children: <Widget>[
                          /* Container(
                            alignment: Alignment.center,
                            child: Text("از"),
                            margin: EdgeInsets.only(right: 14),
                          ),*/
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                                Price.parseFormatted(
                                    snapshot.data.start.toInt()),
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center),
                          ),
                          Expanded(
                            child: RangeSlider(
                              min: 0,
                              divisions: 200,
                              max: 200000,
                              values: snapshot.data,
                              onChanged: (newVal) =>
                                  widget.priceRange.add(newVal),
                            ),
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                                Price.parseFormatted(snapshot.data.end.toInt()),
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center),
                          )
                        ]);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  /*StreamBuilder<int>(
                    stream: widget.maxPrice,
                    builder: (context, snapshot) {
                      if (snapshot != null && snapshot.data != null) {
                        return Row(children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Text("تا"),
                            margin: EdgeInsets.only(right: 14),
                          ),
                          Expanded(
                            child: Slider(
                              divisions: 200,
                              min: 0,
                              max: 200000,
                              value: snapshot.data.toDouble(),
                              onChanged: (newVal) =>
                                  widget.maxPrice.add(newVal.toInt()),
                            ),
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                              Price.parseFormatted(snapshot.data),
                              style: TextStyle(fontSize: 12),textAlign: TextAlign.center,
                            ),
                          )
                        ]);
                      } else {
                        return Container();
                      }
                    },
                  ),*/
                  /* Padding(
                    padding: EdgeInsets.only(right: 20),
                  )*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*

class FilterColCat extends StatelessWidget {
  final void Function(int) filterTabChanged;
  final List<String> items;

  FilterColCat(this.filterTabChanged, this.items);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return (FilterColItem(() => filterTabChanged(index), items[index]));
          }),
    );
  }
}

class FilterColItem extends StatelessWidget {
  final VoidCallback _tapCallback;
  final String _name;

  FilterColItem(this._tapCallback, this._name);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _tapCallback,
        child: Card(
          elevation: 4,
          child: Container(
            height: 40,
            child: Center(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 7,
                  ),
                  Center(child: Text(_name))
                ],
              ),
            ),
          ),
        ));
  }
}


 /*Expanded(
                     child: TextField(
                       onChanged: (newText) {
                         if (num.parse(newText, (e) => null) != null) {
                           widget.minPrice.add(int.parse(newText));
                         }
                       },
*/ /*
                      initialValue: "حداقل قیمت",
                      attribute: "min",*/ /*
                       style: TextStyle(fontSize: 12),
                       decoration: InputDecoration(
                           hintText: "حداقل قیمت",
                           hintStyle: TextStyle(fontSize: 13),
                           labelStyle: TextStyle(fontSize: 13)),
                     ),
                   )*/




            /*BlocBuilder(
          bloc: _filteredProductsBloc,
          builder: (context, state) {

            if (state is LoadingFilteredProducts) {
              return new Center(
                child: new Center(child: LoadingIndicator()),
              );
            } else if (state is FilteredProductsLoaded) {
              var newOps = state.options +
                  [
                    FilterData(PropType(2, "رنگ"),
                        values: ["آبی", 'نارنجی', 'سبز'])
                  ];

              return new Column(
                children: <Widget>[
                  new Expanded(
                    flex: 5,
                    child: StreamBuilder<FilterData>(
                      stream: currentFilters,
                      builder: (context,
                          AsyncSnapshot<FilterData> currentTabSnapshot) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                                flex: 3,
                                child: ListView(
                                  children: newOps
                                      .map((op) => _buildTabItem(
                                              op.type.name,
                                              currentTabSnapshot.data != null &&
                                                  op.type ==
                                                      currentTabSnapshot
                                                          .data.type, () {
                                            currentFilters.add(op);
                                          }))
                                      .toList(),
                                )),
                            Expanded(
                              flex: 5,
                              child: StreamBuilder<List<FilterData>>(
                                  initialData: [],
                                  stream: selectedFiltersStream,
                                  builder: (context,
                                      AsyncSnapshot<List<FilterData>>
                                          selectedFiltersSnapshot) {
                                    if (currentTabSnapshot.data == null) {
                                      return Container();
                                    } else {
                                      print("ssss" +
                                          selectedFiltersSnapshot.data
                                              .toString());
                                      return Container(
                                        child: Wrap(
                                            children: currentTabSnapshot
                                                .data.values
                                                .map((val) {
                                          return _buildFilterItem(
                                              val,
                                              _selectedContains(val,
                                                  selectedFiltersSnapshot.data),
                                              () {
                                            _filterTaped(
                                                currentTabSnapshot.data.type,
                                                val,
                                                selectedFiltersSnapshot.data);
                                          });
                                        }).toList()),
                                      );
                                    }
                                  }),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Divider(),
                  new Expanded(
                      flex: 4,
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 6),
                                height: 25,
                                child: Text(
                                  "مرتب سازی بر اساس:",
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black54),
                                ),
                              ),
                              Expanded(
                                child: SortSelection(),
                              )
                            ],
                          ))),
                  new SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: new FlatButton(
                        onPressed: () {
*/ /*
                          List<FilterData> activeFilters = [];
*/ /*
                          */ /*widget.checkBoxes.forEach((checkBoxWgt) {
                            activeFilters.add(checkBoxWgt.getSelected());

                            */ /* */ /*  }*/ /* */ /* */ /* */ /*else if (o.option is RangeOption) {
                              print("llll ${(o as RangeWidget).selectedMin}");
                              */ /* */ /* */ /* */ /*activeFilters.add(Range(
                                  (o as RangeWidget).selectedMin,
                                  (o as RangeWidget).selectedMax));*/ /* */ /* */ /* */ /*
                            }*/ /* */ /* */ /* */ /*else {
                              print(
                                  "filter_page: filter options of wrong type");
                            }*/ /* */ /*
                          });*/ /*
*/ /*
                          print("FILTER_PAGE: active filters: $activeFilters");
*/ /*
                          */ /*    _filteredProductsBloc
                              .dispatch(UpdateFilter(widget.filters));*/ /*
                          */ /* Provider.of<ProductsBloc>(context)
                              .dispatch(Fetch(widget.identifier));*/ /*
                          */ /*Navigator.of(context).pop();*/ /*
*/ /*
                          widget.applyFilters();
*/ /*
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.main_color,
                                borderRadius: BorderRadius.circular(40)),
                            width: 150,
                            height: 35,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "اعمال فیلتر ها",
                                style: TextStyle(
                                    color: Colors.grey[100], fontSize: 11),
                              ),
                            ),
                          ),
                        )),
                  )
                ],
              );
            } else {
              return Container(
                child: Text("Errorr"),
              );
            }
          }),*/

            /* return Row(
                  children: <Widget>[
                    new Expanded(
                        flex: 3,  ),
                   */ /* new Expanded(
                      flex: 5,
                      child: StreamBuilder<FilterData>(
                          initialData: FilterData(),
                          stream: selectedFiltersStream,
                          builder: (context,
                              AsyncSnapshot<FilterData>
                              selectedFiltersSnapshot) {
                            if (selectedBrands.data ==
                                null) {
                              return Container();
                            } else {
                              print("ssss" +
                                  selectedFiltersSnapshot.data
                                      .toString());
                              return Container(
                                  child: Text(
                                      "sld") */ /**/ /*new Wrap(
                                                children: currentFilterSnapshot
                                                    .data.values
                                                    .map((val) {
                                              return _buildFilterItem(
                                                  val,
                                                  _selectedContains(
                                                      val,
                                                      selectedFiltersSnapshot
                                                          .data), () {
                                                _filterTaped(FilterData(
                                                        brands:
                                                            currentFilterSnapshot
                                                                .data.brands,
                                                        minPrice:
                                                            currentFilterSnapshot
                                                                .data.minPrice,
                                                        maxPrice:
                                                            currentFilterSnapshot
                                                                .data.maxPrice,
                                                        petId: currentFilterSnapshot
                                                            .data.petId,
                                                        catId: currentFilterSnapshot
                                                            .data.catId,
                                                        subCatId:
                                                            currentFilterSnapshot
                                                                .data.subCatId,
                                                        sort:
                                                            currentFilterSnapshot
                                                                .data.sort)
                                                    */ /**/ /* */ /**/ /*currentFilterSnapshot
                                                        .data.type,
                                                    val,
                                                    selectedFiltersSnapshot
                                                        .data*/ /**/ /* */ /**/ /*
                                                    );
                                              });
                                            }).toList()),*/ /**/ /*
                              );
                            }
                          }),
                    )*/ /*
                  ],
                );*/


                  Widget _buildFilterItem(String title, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: new Container(
          width: 100,
          height: 30,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[100],
              border: /*selected ? Border.all(color: Colors.pink[100]) : */ null),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16),
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 11,
                        color:
                            selected ? AppColors.main_color : Colors.grey[600]),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _filterTaped(
      /*PropType filterType, String filterValue,
      List<FilterData> currentFilters*/
      FilterData newFilter) {
    /* bool filtersContainsType =
        currentFilters.map((f) => f.type).toList().contains(filterType);

    if (!_selectedContains(filterValue, currentFilters)) {
      if (filtersContainsType) {
        currentFilters
            .firstWhere((f) => f.type == filterType)
            .values
            .add(filterValue);
      } else {
        currentFilters.add(FilterData(filterType, values: [filterValue]));
      }
    } else {
      if (filtersContainsType) {
        currentFilters
            .firstWhere((f) => f.type == filterType)
            .values
            .remove(filterValue);
      }
    }

    selectedFiltersStream.add(currentFilters);*/
  }

  bool _selectedContains(String filterValue, List<FilterData> selectedFilters) {
    bool found = false;

    /*  selectedFilters.forEach((filter) {
      filter.values.forEach((val) {
        if (val == filterValue) {
          found = true;
        }
      });
    });*/
    return found;
  }

*/
