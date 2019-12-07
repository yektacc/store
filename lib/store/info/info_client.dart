import 'package:store/data_layer/netclient.dart';

class SiteInfoRepository {
  final Net _net;

  SiteInfoRepository(this._net);

  Future<List<SiteInfo>> getSiteInfo() async {
    var res = await _net.post(EndPoint.GET_SITE_INFO);

    if (res is SuccessResponse) {
      final List<Map<String, dynamic>> jsonList = [];
      final List<SiteInfo> infoList = [];

      jsonList.addAll(new List<Map<String, dynamic>>.from(res.data));
      infoList.addAll(
          jsonList.map((infoJson) => SiteInfo.fromJson(infoJson)).toList());

      return infoList;
    } else {
      return [];
    }
  }
}

class SiteInfo {
  final int id;
  final String title;
  final String type;
  final String description;

  SiteInfo(this.id, this.title, this.type, this.description);

  factory SiteInfo.fromJson(Map<String, dynamic> siteInfoJson) {
    return SiteInfo(
      siteInfoJson["id"],
      siteInfoJson["title_fa"].toString(),
      siteInfoJson["type"].toString(),
      siteInfoJson["description"].toString(),
    );
  }
}
