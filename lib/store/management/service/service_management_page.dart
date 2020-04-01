import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/services/chat/inbox_manager.dart';
import 'package:store/services/chat/inbox_widgets.dart';

import '../model.dart';

class ServiceManagementPage extends StatefulWidget {
  static const routeName = 'sercviceManagementPage';

  final ServiceIdentifier _identifier;

  ServiceManagementPage(this._identifier);

  @override
  _ServiceManagementPageState createState() => _ServiceManagementPageState();
}

class _ServiceManagementPageState extends State<ServiceManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: CustomAppBar(
            backgroundColor: Colors.grey[800],
            elevation: 0,
            title: Text(
              "مراکز",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8))),
                  padding: EdgeInsets.only(right: 12, top: 10, bottom: 10),
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.message,
                        color: Colors.grey[700],
                        size: 22,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Text('پیامها'),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  color: Colors.grey[100],
                  padding: EdgeInsets.only(top: 16, bottom: 16, right: 10),
                  height: 380,
                  child: InboxWidget(
                      Provider.of<InboxManager>(context).managerInbox),
                ),
              ],
            ),
          )),
    );
  }

/*Widget _buildClinicItem(ServiceIdentifier service) {
    var provinceRepo = Provider.of<ProvinceRepository>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChatPage(ChatBloc(ChatR),'a',SenderType.CENTER)));
      },
      child: Card(
        elevation: 6,
        child: Container(
            alignment: Alignment.centerRight,
            width: 120,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      service.centerName.toString(),
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(4),
                          bottomLeft: Radius.circular(4))),
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        child: Icon(
                          Icons.location_on,
                          size: 18,
                          color: AppColors.main_color,
                        ),
                        padding: EdgeInsets.only(right: 6, left: 7),
                      ),
                      Container(
                        child: Text(
                          provinceRepo.getCityName(service.cityId),
                          style: TextStyle(color: AppColors.main_color),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }*/
}
