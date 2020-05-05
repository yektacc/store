import 'package:store/data_layer/netclient.dart';

class ServicesRepository {
  final Net net;

  ServicesRepository(this.net);

  Future<List<Service>> getCenterServices(int departmentId) async {
    PostResponse response = await net
        .post(EndPoint.GET_CENTER_SERVICES, body: {'center_department_id': 61});

    print(response);

    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      String items = list[0]['service_id'];

      List<Service> services = [];

      services.addAll(items.split(';').map(parse).toList());

      print("services: " + services.toString());
      return services;
    } else {
      return [];
    }
  }

  Service parse(/*Map<String, dynamic> json*/ String name) {
    return Service(-1, -1, /*json['service_id']*/ name, -1, -1);
  }
}

class Service {
  final int id;
  final int departmentId;
  final String name;
  final int costMin;
  final int costMax;

  Service(this.id, this.departmentId, this.name, this.costMin, this.costMax);

/*factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      json['id'],
      json['center_department_id'],
      json['service_id'],
      json['cost_low'],
      json['cost_high'],
    );
  }*/
}
