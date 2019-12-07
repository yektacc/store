import 'package:store/common/web_client.dart';
import 'package:store/data_layer/netclient.dart';

import 'model.dart';

class StructureRepository {
  final Net _net;

  StructureRepository(this._net);

  Stream<List<StructPet>> fetch() async* {
    var res = await _net.post(EndPoint.GET_STRUCTURE);

    if(res is SuccessResponse) {
      List<Map<String, dynamic>> list =
      new List<Map<String, dynamic>>.from(res.data);

      List<StructPet> pets = list.map((p) => StructPet.fromJson(p)).toList();
      yield pets;
    } else {
      yield [];
    }
    /*if (_cache.isNotEmpty) {
      yield _cache;
    } else {
      await for (final snapshot in _net.handleRequest(StructureReq())) {
        if (snapshot is StructureRes) {
          yield snapshot.pets;
        } else {
          yield [];
        }
      }
    }*/

    /* _client.handleRequest(StructureReq()).listen((response) {
      if (response is StructureRes) {
        return  response.pets;
      } else if (response is FailedRes) {
        print(response.err);
        return [];
      } else {
        print("fetch error");
        return [];
      }
    });*/
  }
}
/*


.firstWhere(((response) {
      print(('response') + response.toString());
      if (response is StructureRes) {
        return response.pets;
      } else if (response is FailedRes) {
        print(response.err);
        return [];
      } else {
        print("fetch error");
        return [];
      }
    }));

    var res = await http.post('http://51.254.65.54/epet24/public/api/getcategorystructure');
    String body = res.body;

    var jsonBody = json.decode(body)['data'];

    List<Map<String,dynamic>> list = new List<Map<String,dynamic>>.from(jsonBody);

    List<Pet> pets = list.map((p) => Pet.fromJson(p)).toList();
    return pets; */
/*

class StructureReq extends WebRequest {
  StructureReq();

  @override
  bool operator ==(Object other) => true;

  // change this if members were added
  @override
  int get hashCode => 0;
}

class StructureRes extends WebResponse {
  final List<StructPet> pets;

  StructureRes(this.pets);
}*/
