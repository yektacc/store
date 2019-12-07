import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/info/info_client.dart';
import 'package:provider/provider.dart';

class InfoPage extends StatefulWidget {
  static const String routeName = 'infopage';


  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<SiteInfo> _fullInfo;
  SiteInfoRepository _repo;

  @override
  Widget build(BuildContext context) {
    if(_repo == null) {
      _repo = Provider.of<SiteInfoRepository>(context);
    }

    _repo.getSiteInfo().then((fullInfo) {
      setState(() {
        _fullInfo = fullInfo;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("اطلاعات"),
      ),
      body: Container(
        child: _fullInfo == null
            ? LoadingIndicator()
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    InfoItem(_fullInfo[index], context),
                itemCount: _fullInfo.length,
              ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem(
    this.item,
    this.context,
  );

  final BuildContext context;
  final SiteInfo item;

  Widget _buildTiles(SiteInfo info) {
    return ExpansionTile(
      backgroundColor: Colors.white,
      key: PageStorageKey(info.title),
      title: Text(info.title),
      children: [
        Container(child: Html(
          data: info.description,
        ),padding: EdgeInsets.only(left: 9,right: 6),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(item);
  }
}
