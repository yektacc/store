import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/services/centers/model.dart';

class CenterFilterWidget extends StatefulWidget {
  final CenterFilter initialFilter;

  final BehaviorSubject<CenterFilter> filters;

  CenterFilterWidget(this.initialFilter)
      : this.filters = BehaviorSubject.seeded(initialFilter);

  @override
  _CenterFilterWidgetState createState() =>
      _CenterFilterWidgetState(initialFilter.type);
}

class _CenterFilterWidgetState extends State<CenterFilterWidget> {
  final CenterFetchType type;
  int currentProvinceId;
  int currentCityId;
  CenterSortType currentSortType = CenterSortType.SCORE;

//  List<FruitsList> fList = [
//    FruitsList(
//      index: 1,
//      name: "Mango",
//    ),
//    FruitsList(
//      index: 2,
//      name: "Apple",
//    ),
//    FruitsList(
//      index: 3,
//      name: "Banana",
//    ),
//    FruitsList(
//      index: 4,
//      name: "Cherry",
//    ),
//  ];

  _CenterFilterWidgetState(this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      height: 250,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: Colors.grey[100],
            child: ProvinceCitySelectionRow((province, city) {
              if (province != null) {
                currentProvinceId = province.id;
              }

              if (city != null) {
                currentCityId = city.id;
              }
            }),
          ),
          Expanded(
              child: Container(
            color: Colors.grey[50],
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    'مرتب‌سازی بر اساس:',
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20, top: 16, bottom: 10),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile(
                        title: Text(
                          "رتبه",
                          style: TextStyle(fontSize: 12),
                        ),
                        groupValue: currentSortType,
                        value: CenterSortType.SCORE,
                        onChanged: (val) {
                          setState(() {
                            currentSortType = val;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text(
                          "جدیدترین",
                          style: TextStyle(fontSize: 12),
                        ),
                        groupValue: currentSortType,
                        value: CenterSortType.NEWEST,
                        onChanged: (val) {
                          setState(() {
                            currentSortType = val;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
          Container(
              height: 56,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Card(
                  color: AppColors.main_color,
                  elevation: 7,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    child: Text(
                      "اعمال فیلترها",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: () {
                  widget.filters.add(CenterFilter(type,
                      provinceId: currentProvinceId ?? -1,
                      cityId: currentCityId ?? -1,
                      sort: currentSortType));
                  Navigator.of(context).pop();
                },
              ))
        ],
      ),
    );
  }
}
