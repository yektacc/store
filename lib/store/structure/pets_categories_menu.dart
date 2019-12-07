import 'package:flutter/material.dart';
import 'package:store/store/structure/structure_page.dart';

import 'model.dart';

class Categories extends StatefulWidget {
  final List<StructPet> pets;
  final Function(StructPet pet) onPetChanged;

  Categories(this.pets, this.onPetChanged);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final List<CategoryItem> _data = [];

  StructPet selectedPet;

  List<CategoryItem> generateItems(StructPet pet) => pet.categories
      .map((category) => CategoryItem(category: category))
      .toList();

  void updatePet(StructPet pet) {
    if (selectedPet == pet) {
      setState(() {
        selectedPet = null;
        _data.clear();
      });
    } else {
      setState(() {
        selectedPet = pet;
        _data.clear();
        _data.addAll(generateItems(pet));
      });
    }

    widget.onPetChanged(selectedPet);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          /* Column(
        children: <Widget>[_buildCategories(), _buildPetMenu()]*/
          PetMenu(widget.pets, (index) {
        updatePet(widget.pets[index]);
      }),
    );
  }
}

class PetMenu extends StatefulWidget {
  final List<StructPet> pets;
  final Function(int index) onPetChange;

  PetMenu(this.pets, this.onPetChange);

  @override
  _PetMenuState createState() => _PetMenuState();
}

class _PetMenuState extends State<PetMenu> with TickerProviderStateMixin {
/*
  final double height = 150;
*/

  /* double width;
  int selected = -1;
  Animation<double> gridListAnimation;
  AnimationController gridListAnimController;
  int prevSelected = -2;*/

/*  Animation<double> updateAnimation;
  AnimationController updateAnimController;*/

  void initState() {
    super.initState();
  }

/*  _handleTap(int index) {
    if (selected == -1) {
      print("case1");

      prevSelected = selected;
      selected = index;
      currentPet.updatePet(IndexedPet.fromPet(widget.pets[index], index));

*/ /*
      widget.onPetChange(selected);
*/ /*
      gridListAnimController.forward();
    } else if (selected == index) {
      print("case2");
      setState(() {
        prevSelected = selected;
        selected = -1;
        currentPet.updatePet(null);
*/ /*
        widget.onPetChange(selected);
*/ /*
      });

      gridListAnimController.reverse();
    } else {
      print("case3");
      setState(() {
        prevSelected = selected;
        selected = index;
        currentPet.updatePet(IndexedPet.fromPet(widget.pets[index], index));

*/ /*
        widget.onPetChange(selected);
*/ /*
      });

      gridListAnimController.reset();
      gridListAnimController.forward();
//      setState(() {});
    }
  }*/

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /*width = MediaQuery.of(context).size.width;
    gridListAnimController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    gridListAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });*/
/*    updateAnimController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);*/

    /* gridListAnimation =
        CurvedAnimation(parent: gridListAnimController, curve: Curves.easeIn);*/
/*    updateAnimation =
        CurvedAnimation(parent: gridListAnimController, curve: Curves.easeIn);*/
  }

  @override
  void dispose() {
/*
    gridListAnimController.dispose();
*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StructureMenu(widget.pets),
      width: 200,
      height: 200,
      color: Colors.red,
    );
    /*Container(
      child: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          PetItem(),
          PetItem(),
          PetItem(),
          PetItem(),
        ],
      ),
      height: 400,
    );*/
  }
}

/*
class PetItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Text("23"),
      ),
    );
  }
}
*/

/* new Container(
        height: widget.pets.length * height,
        color: Colors.white,
        child: Stack(
          children: List.generate(widget.pets.length, (index) {
            final pet = widget.pets[index];
            return AnimatedPetItem(
              height,
              width,
              index,
              /*new Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        pet.nameFA,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[900],
                            fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Container(
                        height: 40,
                        width: 40,
                        child: AppIcons.pets[index],
                      ) */ /*Icon(
                        Icons.pets,
                        size: 80,
                        color: AppColors.colors[index],
                      )*/ /*
                      ,
                    ),
                  )
                ],
              ),*/
              FlatButton(
                onPressed: () => _handleTap(index),
                child: Container(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      children: <Widget>[
                        Text(
                          pet.nameFA,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                              fontSize: 15),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 35,
                              width: 35,
                              child: AppIcons.pets[index],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: () => _handleTap(index),
                        child: Container(
                          child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    pet.nameFA,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey[900],
                                        fontSize: 15),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        child: AppIcons.pets[index],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      )),
                  Divider(),
                  Expanded(
                    flex: 4,
                    child: Wrap(
                      children: List.generate(pet.categories.length, (i) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17)),
                            color: AppColors.colors[index],
                            onPressed: () {
                              Provider.of<FilteredProductsBloc>(context)
                                  .dispatch(UpdateFilter([]));
                              Navigator.of(context).push(AppRoutes.productsPage(
                                  context, pet.categories[i]));
                            },
                            child: Text(
                              pet.categories[i].nameFA,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
              () => _handleTap(index),
              selected,
              prevSelected,
              Colors.white,
              animation: gridListAnimation,
            );
          }),
        ),
      )*/

/*

class AnimatedPetItem extends AnimatedWidget {
  final double baseHeight;
  final double width;

*/
/*
  final Widget collapsedChild;
*/ /*

  final Widget expandedChild;
  final Widget activeChild;

  final Color color;

  final VoidCallback onClick;

  final int index;
  final int activeIndex;
  final int prevActiveIndex;

  Tween<double> _topPositionTween;
  Tween<double> _rightPositionTween;
  Tween<double> _widthTween;
  Tween<double> _heightTween;

  Tween<double> _updateTopPositionTween;
  Tween<double> _updateHeightTween;

  int row;
  int col;

  AnimatedPetItem(
      this.baseHeight,
      this.width,
      this.index,
*/
/*
      this.collapsedChild,
*/ /*

      this.expandedChild,
      this.activeChild,
      this.onClick,
      this.activeIndex,
      this.prevActiveIndex,
      this.color,
      {Key key,
      Animation<double> animation})
      : super(key: key, listenable: animation) {
    print("maaaade");
    double activeHeight = baseHeight * 2;
    double deactiveHeight = baseHeight / 2;

    col = index % 2;
    row = index ~/ 2;

    // grid list tweens
    _topPositionTween = Tween<double>(
        begin: row * baseHeight,
        end: activeIndex == index
            ? index * deactiveHeight
            : activeIndex > index
                ? index * deactiveHeight
                : (index - 1) * deactiveHeight + activeHeight);
    _rightPositionTween =
        Tween<double>(begin: col == 0 ? 0 : width / 2, end: 0);

    _widthTween = Tween<double>(begin: width / 2, end: width);

    _heightTween = Tween<double>(
        begin: baseHeight,
        end: activeIndex == index ? activeHeight : deactiveHeight);

    // update tweens
    _updateTopPositionTween = Tween<double>(
        begin: prevActiveIndex == index
            ? index * deactiveHeight
            : prevActiveIndex > index
                ? index * deactiveHeight
                : (index - 1) * deactiveHeight + activeHeight,
        end: activeIndex == index
            ? index * deactiveHeight
            : activeIndex > index
                ? index * deactiveHeight
                : (index - 1) * deactiveHeight + activeHeight);

    _updateHeightTween = Tween<double>(
        begin: prevActiveIndex == index ? activeHeight : deactiveHeight,
        end: activeIndex == index ? activeHeight : deactiveHeight);

    */
/*_heightUpdateTween = Tween<double>(
        begin: activeIndex == index ? baseHeight,
        end: activeIndex == index ? baseHeight * 1.5 : baseHeight / 2);*/ /*

  }

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    if (activeIndex == -1) {
      print(
          "SMALL activeINdex:  $activeIndex, pevActiveindex: $prevActiveIndex");
      return Positioned(
        top: _topPositionTween.evaluate(animation),
        right: _rightPositionTween.evaluate(animation),
        width: _widthTween.evaluate(animation),
        child: Container(
          height: _heightTween.evaluate(animation),
          child: Card(
            color: color,
            child: GestureDetector(
              child: collapsedChild,
              onTap: onClick,
            ),
          ),
        ),
      );
    } else if (prevActiveIndex == -1) {
      print(
          "SMALL activeINdex:  $activeIndex, pevActiveindex: $prevActiveIndex");
      return Positioned(
        top: _topPositionTween.evaluate(animation),
        right: _rightPositionTween.evaluate(animation),
        width: _widthTween.evaluate(animation),
        child: Container(
          height: _heightTween.evaluate(animation),
          child: Card(
            elevation: activeIndex == index ? 10 : 4,
            color: color,
            child: GestureDetector(
              child: activeIndex == index ? activeChild : expandedChild,
              onTap: onClick,
            ),
          ),
        ),
      );
    } else {
      print("BIG activeINdex:  $activeIndex, pevActiveindex: $prevActiveIndex");
      return Positioned(
        top: _updateTopPositionTween.evaluate(animation),
        right: 0,
        width: width,
        child: Container(
          height: _updateHeightTween.evaluate(animation),
          child: Card(
            elevation: activeIndex == index ? 10 : 4,
            color: color,
            child: GestureDetector(
              child: activeIndex == index ? activeChild : expandedChild,
              onTap: onClick,
            ),
          ),
        ),
      );
    }
  }
}
*/
