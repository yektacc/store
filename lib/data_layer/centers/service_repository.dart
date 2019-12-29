import 'package:store/data_layer/netclient.dart';

class ServicesRepository {
  final Net net;

  ServicesRepository(this.net);

  Stream<List<Service>> getCenterServices(int centerId) async* {
    PostResponse response = await net.post(
      EndPoint.GET_CENTER_SERVICES,
        body: {'center_department_id': centerId}
    );

    print(response);

    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      print("list" + list.toString());
      List<Service> services = [];

      services.addAll(list.map(parse).toList());

      print("services: " + services.toString());
      yield services;
    } else {
      yield [];
    }
  }

  Service parse(Map<String, dynamic> json) {
    return Service(-1, -1, json['service_id'], -1, -1);
  }
}

class Service {
  final int id;
  final int departmentId;
  final String serviceName;
  final int costMin;
  final int costMax;

  Service(
      this.id, this.departmentId, this.serviceName, this.costMin, this.costMax);

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
