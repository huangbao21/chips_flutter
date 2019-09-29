import 'dart:async';

import 'package:chips_flutter/hobbies_widget.dart';
import 'package:chips_flutter/redux_actions.dart';
import 'package:flutter/material.dart';
import 'package:chips_flutter/utils.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

import 'app_state.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController tec = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state.personalInfo,
      builder: (context, personalInfo) {
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
              '编辑资料',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(Utils.dcImage(
                              personalInfo['user_info']['icon_big'])))),
                  child: FlatButton(
                    shape: StadiumBorder(),
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    onPressed: () async {
                      var result = await platformNavigator(context,
                          targetPage: PlatformCmd.EDIT_AVATAR);
                      if (result != null) {
                        var res = await Utils.requestHttp(
                            url: '/update_profile',
                            context: context,
                            data: {'icon_big': result},
                            method: 'post',
                            beforeLoading: true);
                        if (res != null) {
                          store.dispatch(GetPersonalInfoAction(res, null,
                              offlineUpdate: true));
                        }
                      }
                    },
                    child: Text(
                      '点击修改头像',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 12, right: 12, top: 5),
                  child: Column(
                    children: <Widget>[
                      _customTile(
                          leading: '昵称',
                          content: Text(
                            '${personalInfo['user_info']['nick']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () async {
                            {
                              String result = await _editBaseInfoDialog(
                                  'nick', personalInfo['user_info']['nick']);
                              if (result != null) {
                                var res = await Utils.requestHttp(
                                    url: '/update_profile',
                                    context: context,
                                    data: {'nick': result},
                                    method: 'post',
                                    beforeLoading: true);
                                if (res != null) {
                                  store.dispatch(GetPersonalInfoAction(
                                      res, null,
                                      offlineUpdate: true));
                                }
                              }
                            }
                          }),
                      _customTile(
                          leading: '性别',
                          content: Text(
                              '${personalInfo['user_info']['gender']}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () async {
                            String result = await _editBaseInfoDialog(
                                'gender', personalInfo['user_info']['gender']);
                            if (result != null) {
                              var res = await Utils.requestHttp(
                                  url: '/update_profile',
                                  context: context,
                                  data: {'gender': result},
                                  method: 'post',
                                  beforeLoading: true);
                              if (res != null) {
                                store.dispatch(GetPersonalInfoAction(res, null,
                                    offlineUpdate: true));
                              }
                            }
                          }),
                      _customTile(
                          leading: '生日',
                          content: Text(
                              '${personalInfo['user_info']['birth'] ??= '2000-01-01'}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () async {
                            var temp =
                                personalInfo['user_info']['birth'].split("-");
                            DatePicker.showDatePicker(context,
                                minDateTime: DateTime(1900),
                                maxDateTime: DateTime.now(),
                                initialDateTime: DateTime(int.parse(temp[0]),
                                    int.parse(temp[1]), int.parse(temp[2])),
                                dateFormat: "yyyy-MM-dd",
                                locale: DateTimePickerLocale.zh_cn, onConfirm:
                                    (DateTime dateTime,
                                        List<int> values) async {
                              print(dateTime.toString());
                              print(DateFormat('yyyy-MM-dd').format(dateTime));
                              print(values);
                              var res = await Utils.requestHttp(
                                  url: '/update_profile',
                                  context: context,
                                  data: {
                                    'birth': DateFormat('yyyy-MM-dd')
                                        .format(dateTime)
                                  },
                                  method: 'post',
                                  beforeLoading: true);
                              if (res != null) {
                                store.dispatch(GetPersonalInfoAction(res, null,
                                    offlineUpdate: true));
                              }
                            });
                          }),
                      _customTile(
                          leading: '学校',
                          content: Text(
                              '${personalInfo['user_info']['school']}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () async {
                            if (personalInfo['user_info']['school'] == '薯条大学') {
                              var schoolId = await platformNavigator(context,
                                  targetPage: PlatformCmd.CHANGE_SCHOOL);
                              if (schoolId != null) {
                                var res = await Utils.requestHttp(
                                    url: '/update_profile',
                                    context: context,
                                    data: {'school_id': schoolId},
                                    method: 'post',
                                    beforeLoading: true);
                                if (res != null) {
                                  store.dispatch(GetPersonalInfoAction(
                                      res, null,
                                      offlineUpdate: true));
                                }
                              }
                            }
                          },
                          trail: personalInfo['user_info']['school'] == '薯条大学'
                              ? true
                              : false),
                      _customTile(
                          leading: '兴趣爱好',
                          content: DefaultTextStyle(
                            style: TextStyle(
                                color: Color.fromRGBO(108, 184, 255, 1)),
                            child: Row(
                              children: _userHobby(
                                  personalInfo['user_info']['member_label']),
                            ),
                          ),
                          paddingLeft: 15,
                          onTap: () async {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return HobbiesPage();
                            }));
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _customTile(
      {String leading,
      double paddingLeft = 45,
      Widget content,
      void onTap(),
      bool trail = true}) {
    return Material(
      color: Colors.white,
      child: Ink(
        padding: EdgeInsets.only(bottom: 10),
        child: InkWell(
          highlightColor: Color.fromRGBO(243, 243, 243, 1),
          onTap: onTap,
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 15, color: Colors.black),
            child: Container(
              height: 30,
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('$leading'),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(left: paddingLeft),
                      child: content,
                    ),
                  ),
                  trail
                      ? Icon(
                          Icons.arrow_forward_ios,
                          color: Color.fromRGBO(102, 102, 102, 1),
                          size: 20,
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _userHobby(hobbies) {
    List<Widget> hobbiesWidget = [];
    for (var i = 0; i < hobbies.length; i++) {
      var container = Container(
        padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(108, 184, 255, 1)),
            color: Color.fromRGBO(240, 248, 255, 1),
            borderRadius: BorderRadius.circular(20)),
        child: Text('${hobbies[i]['name']}'),
      );
      hobbiesWidget.add(container);
    }
    return hobbiesWidget;
  }

  // 修改昵称、性别
  Future _editBaseInfoDialog(String type, String oldVal) async {
    Widget sd;
    String result;
    if (type == 'gender') {
      sd = Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 220,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 150,
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: <Widget>[
                        Text(
                          '请选择性别',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              decoration: TextDecoration.none),
                        ),
                        GestureDetector(
                          onTap: () {
                            result = '男';
                            Navigator.of(context).pop(result);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 30, bottom: 5),
                            child: Text('男',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none)),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[200],
                        ),
                        GestureDetector(
                          onTap: () {
                            result = '女';
                            Navigator.of(context).pop(result);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width,
                            child: Text('女',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: TextDecoration.none)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '取消',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )));
    } else {
      tec.text = oldVal;

      sd = SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.all(10),
        title: Text(
          '修改昵称',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        titlePadding: EdgeInsets.symmetric(vertical: 12),
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              maxLength: 10,
              controller: tec,
              decoration: InputDecoration(
                focusedErrorBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(153, 153, 153, 1))),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(153, 153, 153, 1))),
              ),
              autofocus: true,
              validator: (v) {
                return v.trim().length > 0 ? null : '昵称不能为空';
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              result = tec.text;
              if ((_formKey.currentState as FormState).validate()) {
                if (result.length < 11) {
                  Navigator.of(context).pop(result);
                }
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(247, 203, 28, 1),
                        Color.fromRGBO(255, 167, 51, 1)
                      ])),
              child: Text(
                '保存',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      );
    }
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return sd;
        });
    return result;
  }
}
