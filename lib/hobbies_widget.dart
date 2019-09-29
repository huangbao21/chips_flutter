import 'package:chips_flutter/redux_actions.dart';
import 'package:chips_flutter/utils.dart';
import 'package:flutter/material.dart';

class HobbiesPage extends StatefulWidget {
  @override
  _HobbiesPageState createState() => _HobbiesPageState();
}

class _HobbiesPageState extends State<HobbiesPage> {
  var hobbyList;
  int selectCount = 0;
  // var savedUserInfo;
  BuildContext scaffoldCtx;
  @override
  void initState() {
    super.initState();
    Utils.requestHttp(
        url: '/user_label_list',
        context: context,
        method: 'get',
        callback: (json) {
          setState(() {
            hobbyList = json;
            hobbyList.forEach((hobby) {
              if (hobby['sign'] == 1) selectCount++;
            });
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const BackButtonIcon(),
          color: Colors.black,
          onPressed: () {
              Navigator.pop(context);
          },
        ),
        title: Text(
          '选择兴趣标签',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        scaffoldCtx = context;
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text.rich(TextSpan(
                children: [
                  TextSpan(text: '当前已选'),
                  TextSpan(
                      text: '$selectCount',
                      style: TextStyle(color: Colors.red)),
                  TextSpan(text: '/3')
                ],
                style: TextStyle(
                  fontSize: 15,
                ),
              )),
              DefaultTextStyle(
                style: TextStyle(fontSize: 16, color: Colors.black),
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.only(left: 13),
                  width: double.infinity,
                  child: _hobbyListData(),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectCount > 0) {
                        List labels = [];
                        hobbyList.forEach((hobby) {
                          if (hobby['sign'] == 1) {
                            labels.add(hobby['id']);
                          }
                        });
                        var res = await Utils.requestHttp(
                            url: '/update_profile',
                            context: context,
                            data: {'label': labels.join(",")},
                            method: 'post');
                        if (res != null) {
                          store.dispatch(GetPersonalInfoAction(res,null,offlineUpdate: true));
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15),
                      alignment: Alignment.center,
                      width: 230,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: selectCount == 0
                                ? [Colors.grey[400], Colors.grey[400]]
                                : [
                                    Color.fromRGBO(95, 210, 255, 1),
                                    Color.fromRGBO(90, 176, 255, 1),
                                  ]),
                      ),
                      child: Text(
                        '保存',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _hobbyListData() {
    List<Widget> containerList = [];
    if (hobbyList == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      for (var i = 0; i < hobbyList.length; i++) {
        var container = GestureDetector(
          onTap: () {
            setState(() {
              hobbyList[i]['sign'] = hobbyList[i]['sign'] == 0 ? 1 : 0;
              if (hobbyList[i]['sign'] == 1) {
                selectCount++;
                if (selectCount > 3) {
                  selectCount--;
                  hobbyList[i]['sign'] = 0;
                }
              } else {
                selectCount--;
              }
            });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
            decoration: BoxDecoration(
                border: hobbyList[i]['sign'] == 1
                    ? Border.all(color: Color.fromRGBO(108, 184, 255, 1))
                    : Border.all(color: Colors.transparent),
                color: hobbyList[i]['sign'] == 1
                    ? Color.fromRGBO(240, 248, 255, 1)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              '${hobbyList[i]['name']}',
              style: TextStyle(
                  color: hobbyList[i]['sign'] == 1
                      ? Color.fromRGBO(108, 184, 255, 1)
                      : Colors.black),
            ),
          ),
        );
        containerList.add(container);
      }
      return Wrap(
        runSpacing: 15,
        spacing: 15,
        children: containerList,
      );
    }
  }
}
