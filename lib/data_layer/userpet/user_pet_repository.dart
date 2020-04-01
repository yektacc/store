import 'dart:core';

import '../netclient.dart';

class UserPetRepository {
  final Net _client;

  UserPetRepository(this._client);

  Future<UserPet> get(int appUserId) async {
    PostResponse response = await _client.post(EndPoint.GET_USER_PET,
        cacheEnabled: false, body: {'app_users_id': appUserId.toString()});
    if (response is SuccessResponse) {
      try {
        List petJson = List<Map<String, dynamic>>.from(response.data);
        return UserPet.fromJson(petJson[0]);
      } catch (e) {
        print('Error parsin UserPet json' + e);
        return NotSetUserPet();
      }
    } else {
      print("Error loading user pet $response");
      return null;
    }
  }

  Future<bool> send(UserPet pet) async {
    PostResponse response = await _client.post(EndPoint.SEND_USER_PET, body: {
//      'id': pet.id,
      'app_users_id': pet.userId.toString(),
      'animal_name': pet.name == '' ? 'null' : pet.name,
      'animal_image': pet.imgUrl,
      'animal_age': pet.age,
      'gender_id': pet.genderId.toString(),
      'type_id': pet.typeId.toString(),
      'sterilization_id': pet.sterilizationId.toString(),
    });

    if (response is SuccessResponse) {
      return true;
    } else {
      print("Error setting user pet $response");
      return false;
    }
  }

  Future<bool> edit(UserPet pet) async {
    PostResponse response = await _client.post(EndPoint.EDIT_USER_PET, body: {
      'id': pet.id,
      'app_users_id': pet.userId.toString(),
      'animal_name': pet.name,
      'animal_image': pet.imgUrl,
      'animal_age': pet.age.toString(),
      'gender_id': pet.genderId.toString(),
      'type_id': pet.typeId.toString(),
      'sterilization_id': pet.sterilizationId.toString(),
    });

    if (response is SuccessResponse) {
      return true;
    } else {
      print("Error setting user pet $response");
      return false;
    }
  }

  Future<bool> delete(int userPetId) async {
    PostResponse response = await _client.post(EndPoint.DELETE_USER_PET, body: {
      'id': userPetId.toString(),
    });

    if (response is SuccessResponse) {
      return true;
    } else {
      print("Error setting user pet $response");
      return false;
    }
  }
}

class UserPet {
  final int id;
  final int userId;
  final String name;
  final String imgUrl;
  final int age;
  final int genderId;
  final int typeId;
  final int sterilizationId;

  UserPet(this.id, this.userId, this.name, this.imgUrl, this.age, this.genderId,
      this.typeId, this.sterilizationId);

  factory UserPet.fromJson(Map<String, dynamic> json) {
    try {
      return UserPet(
        json['id'],
        json['app_user_id'],
        json['animal_name'],
        json['animal_image'],
        json['animal_age'] == null || json['animal_age'].toString() == 'null'
            ? -1
            : int.parse(json['animal_age'], onError: (_) => -1),
        json['gender_id'] == null || json['gender_id'].toString() == 'null'
            ? -1
            : json['gender_id'],
        json['type_id'] ?? -1,
        json['sterilization_id'] == null ||
                json['sterilization_id'].toString() == 'null'
            ? -1
            : json['sterilization_id'],
      );
    } catch (e, st) {
      print(e);
      print(st);
      return null;
    }
  }
}

class NotSetUserPet extends UserPet {
  NotSetUserPet() : super(-1, -1, '', '', 0, 0, 0, 0);
}
