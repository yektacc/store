import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/common/widgets/form_fields.dart';
import 'package:store/store/userpet/user_pet_bloc.dart';
import 'package:store/store/userpet/user_pet_bloc_event_state.dart';

class UserPetPage extends StatefulWidget {
  @override
  _UserPetPageState createState() => _UserPetPageState();
}

class _UserPetPageState extends State<UserPetPage> {
  BehaviorSubject<int> userPetId = BehaviorSubject.seeded(-1);
  BehaviorSubject<int> petTypeId = BehaviorSubject.seeded(-1);
  BehaviorSubject<String> petName = BehaviorSubject.seeded('');
  BehaviorSubject<int> petAge = BehaviorSubject.seeded(-1);
  BehaviorSubject<int> petGender = BehaviorSubject.seeded(-1);
  BehaviorSubject<int> petSterilizationId = BehaviorSubject.seeded(-1);

  UserPetBloc _userPetBloc;

  @override
  Widget build(BuildContext context) {
    if (_userPetBloc == null) {
      _userPetBloc = Provider.of<UserPetBloc>(context);
      _userPetBloc.dispatch(FetchUserPet());
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.main_color,
        onPressed: () {
          var selectedType = petTypeId.value;
          var selectedName = petName.value;
          var selectedAge = petAge.value;
          var selectedGender = petGender.value;
          var selectedSterilization = petSterilizationId.value;
          var itemId = userPetId.value;

          _userPetBloc.dispatch(SetUserPet(
              itemId,
              selectedAge,
              selectedSterilization,
              selectedGender,
              selectedType,
              selectedName));
        },
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      appBar: CustomAppBar(
        titleText: 'حیوان خانگی شما',
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.grey[800],
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        light: true,
        elevation: 0,
      ),
      body: BlocBuilder(
        bloc: _userPetBloc,
        builder: (context, state) {
          print('state' + state.toString());
          if (state is UserPetLoaded || state is UserPetNotSet) {
            if (state is UserPetLoaded) {
              if (userPetId.value == -1) {
                userPetId.add(state.userPet.id);
              }

              if (petTypeId.value == -1) {
                petTypeId.add(state.userPet.typeId);
              }

              if (petAge.value == -1) {
                petAge.add(state.userPet.age);
              }

              if (petSterilizationId.value == -1) {
                petSterilizationId.add(state.userPet.sterilizationId);
              }

              if (petGender.value == -1) {
                petGender.add(state.userPet.genderId);
              }

              if (petName.value == '') {
                petName.add(state.userPet.name);
              }
            }

            return ListView(
              children: <Widget>[
                PetTypeSelectionWidget(petTypeId),
                _buildNameSelection(),
                _buildAgeSelection(),
                Divider(),
//                _buildSterilizationWidget(),
                _buildGenderSelectionWidget(),
              ],
            );
          } else if (state is UserPetLoading) {
            return LoadingIndicator();
          } else if (state is UserPetLoadingFailed) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildNameSelection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: StreamBuilder<String>(
        stream: petName,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              child: FormFields.text('نام', null, onChange: petName.add)

              /* TextFormField(
                initialValue: snapshot.data,
                onChanged: petName.add,
                cursorColor: AppColors.main_color,
                decoration: InputDecoration(
                  labelText: "نام حیوان",
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.main_color))),
              )*/
              ,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildAgeSelection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.only(bottom: 28),
      child: StreamBuilder<int>(
        stream: petAge,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              child: TextFormField(
                maxLength: 2,
                keyboardType: TextInputType.number,
                initialValue: snapshot.data == -1 || snapshot.data == 0
                    ? ''
                    : snapshot.data.toString(),
                onChanged: (newText) {
                  try {
                    petAge.add(int.parse(newText));
                  } catch (e) {}
                },
                cursorColor: AppColors.main_color,
                decoration: InputDecoration(
                    counterText: '',
                    labelText: "سن حیوان",
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.main_color))),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildGenderSelectionWidget() {
    const String male = "     نر     ";
    const String female = "      ماده      ";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: StreamBuilder<int>(
        stream: petGender,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              child: RadioButtonGroup(
                activeColor: AppColors.main_color,
                padding: EdgeInsets.symmetric(horizontal: 20),
                orientation: GroupedButtonsOrientation.HORIZONTAL,
                picked: petGender.value == 1 ? female : male,
                labels: [
                  male,
                  female,
                ],
                onSelected: (selected) {
                  switch (selected) {
                    case male:
                      petGender.add(0);
                      break;

                    case female:
                      petGender.add(1);
                      break;
                  }
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildSterilizationWidget() {
    const String sterilizedLabel = "     عقیم شده     ";
    const String notSterilizedLabel = "      عقیم نشده      ";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: StreamBuilder<int>(
        stream: petSterilizationId,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              child: RadioButtonGroup(
                orientation: GroupedButtonsOrientation.HORIZONTAL,
                activeColor: AppColors.main_color,
                picked: petSterilizationId.value == 1
                    ? sterilizedLabel
                    : notSterilizedLabel,
                labels: [
                  sterilizedLabel,
                  notSterilizedLabel,
                ],
                onSelected: (selected) {
                  switch (selected) {
                    case sterilizedLabel:
                      petSterilizationId.add(1);
                      break;

                    case notSterilizedLabel:
                      petSterilizationId.add(0);
                      break;
                  }
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    userPetId.close();
    petTypeId.close();
    petName.close();
    petSterilizationId.close();
    petGender.close();
    petAge.close();
    super.dispose();
  }
}

class PetTypeSelectionWidget extends StatefulWidget {
  final BehaviorSubject<int> selectedPet;

  PetTypeSelectionWidget(this.selectedPet);

  @override
  _PetTypeSelectionWidgetState createState() => _PetTypeSelectionWidgetState();
}

class _PetTypeSelectionWidgetState extends State<PetTypeSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.selectedPet,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              height: 300,
              child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  children: [0, 1, 2, 3]
                      .map((index) => GestureDetector(
                            onTap: () {
                              widget.selectedPet.add(index);
                            },
                            child: _buildPetItem(index, index == snapshot.data),
                          ))
                      .toList()),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _buildPetItem(int index, bool selected) {
    var name;

    switch (index) {
      case 0:
        name = 'سگ';
        break;
      case 1:
        name = 'گربه';
        break;
      case 2:
        name = 'پرندگان';
        break;
      case 3:
        name = 'اسب';
        break;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
          color: selected ? Colors.grey[50] : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(
              color: selected ? AppColors.main_color : Colors.red[50])),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
            child: AppIcons.pets[index],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              name,
              style: TextStyle(
                  color: AppColors.second_color, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
