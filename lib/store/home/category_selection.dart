/*
import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/products/product/products_page.dart';

import 'home_page.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      padding: Spaces.listInsets,
      child: GridView.count(
        childAspectRatio: (4 / 7),
        crossAxisCount: 2,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CategoryItem(AppColors.colors[0], "غذا و مکمل سگ", AppIcons.pets[0]),
          CategoryItem(
              AppColors.colors[1], "غذا و مکمل گربه", AppIcons.pets[1]),
          CategoryItem(
              AppColors.colors[2], "غذا و مکمل پرندگاه", AppIcons.pets[2]),
          CategoryItem(
              AppColors.colors[0], "جای خواب و نگهداری سگ", AppIcons.pets[0]),
          CategoryItem(
              AppColors.colors[1], "جای خواب و نگهداری گربه", AppIcons.pets[1]),
          CategoryItem(AppColors.colors[2], "جای خواب و نگهداری پرندگاه",
              AppIcons.pets[2]),
          */
/*CategoryItem(AppColors.colors[1]),
          CategoryItem(AppColors.colors[0])*//*

        ],
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  final Color color;
  final String title;
  final Widget icon;

  CategoryItem(this.color, this.title, this.icon);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).popAndPushNamed(ProductsPage.routeName);
      },
      child: Card(
        elevation: 3,
        margin: Spaces.listInsets,
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3),
                          bottomRight: Radius.circular(12))),
                  height: 40,
                  width: 40,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: widget.icon,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/
