import 'dart:core';

import '../netclient.dart';

class AdsRepository {
  final Net _client;

  AdsRepository(this._client);

  Future<List<Ad>> fetch() async {
    PostResponse response = await _client.post(EndPoint.GET_ADS);
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      return list
          .map(parse)
          .where((ad) => !ad.position.startsWith("M"))
          .toList();
    } else {
      return [];
    }
  }

  Ad parse(Map<String, dynamic> json) {
    return Ad(
        json['id'],
        json['url'],
        json['title_fa'],
        json['image'],
        json['page_location'],
        DateTime.parse(json['start_datetime'].toString()),
        DateTime.parse(json['stop_datetime'].toString()));
  }
}

class Ad {
  final int id;
  final String title;
  final String url;
  final String imgUrl;
  final String position;
  final DateTime startDateTime;
  final DateTime endDateTime;

  Ad(this.id, this.url, this.title, this.imgUrl, this.position,
      this.startDateTime, this.endDateTime);
}
