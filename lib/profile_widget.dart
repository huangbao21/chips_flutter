import 'dart:convert';

import 'package:chips_flutter/edit_widget.dart';
import 'package:chips_flutter/utils.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:chips_flutter/app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:toast/toast.dart';

import 'redux_actions.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.otherUserId}) : super(key: key);

  final String otherUserId;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  OverlayEntry overlayMenuEntry;
  bool showVisitEntry = true;
  GlobalKey _globalKey = GlobalKey();
  // max: 399,other:319
  Map floatHeight = {'max': 399, 'other': 319, 'own': 299, 'result': 0};
  BuildContext scaffoldCtx;
  @override
  void initState() {
    super.initState();
    store.dispatch(GetPersonalInfoAction(null, widget.otherUserId));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      if (overlayMenuEntry != null) {
        overlayMenuEntry.remove();
      }
      return await platformNavigator(context);
    }, child: Scaffold(body: Builder(
      builder: (BuildContext context) {
        scaffoldCtx = context;
        return StoreConnector<AppState, dynamic>(
            converter: (store) => store.state.personalInfo,
            builder: (context, personalInfo) {
              if (personalInfo != null) {
                floatHeight['result'] = widget.otherUserId == null
                    ? floatHeight['own']
                    : personalInfo['user_status'] == 3
                        ? floatHeight['max']
                        : floatHeight['other'];
              }
              return DefaultTextStyle(
                  style: TextStyle(color: Colors.white),
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Stack(children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width -
                                36 +
                                floatHeight['result'] +
                                10,
                            color: Color.fromRGBO(246, 246, 246, 1),
                            // color: Colors.red,
                          ),
                          personalInfo != null
                              ? Image.network(
                                  Utils.dcImage(
                                      personalInfo['user_info']['icon_big']),
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                )
                              : Image.asset(
                                  'images/profile/bg_mengban.png',
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                          Image.asset(
                            'images/profile/bg_mengban.png',
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.width - 127,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      personalInfo != null
                                          ? "${personalInfo['user_info']['nick']}"
                                          : '***',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    _actionButton(personalInfo)
                                  ],
                                ),
                                Text(
                                  "薯条号：${personalInfo != null ? personalInfo['user_info']['user_id'] : ''}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                DefaultTextStyle(
                                    style: TextStyle(fontSize: 11),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 12),
                                      child: Row(
                                        children: <Widget>[
                                          personalInfo != null &&
                                                  personalInfo['user_info']
                                                          ['gender'] ==
                                                      '男'
                                              ? Image.asset(
                                                  'images/profile/icon_man.png',
                                                  width: 15,
                                                )
                                              : Image.asset(
                                                  'images/profile/icon_women.png',
                                                  width: 15,
                                                ),
                                          Container(
                                            width: 30,
                                            margin: EdgeInsets.only(
                                                left: 2, right: 12),
                                            decoration: BoxDecoration(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .4),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: Text(
                                              "${personalInfo != null ? personalInfo['user_info']['age'] : ''}",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Image.asset(
                                            'images/profile/icon_xingzuo.png',
                                            width: 15,
                                          ),
                                          Container(
                                            width: 49,
                                            margin: EdgeInsets.only(
                                                left: 2, right: 12),
                                            decoration: BoxDecoration(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: Text(
                                              "${personalInfo != null ? personalInfo['user_info']['constellation'] : ''}",
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Image.asset(
                                            'images/profile/icon_xuexiao.png',
                                            width: 15,
                                          ),
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    200),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6),
                                            margin: EdgeInsets.only(left: 2),
                                            decoration: BoxDecoration(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .4),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: Text(
                                              "${personalInfo != null ? personalInfo['user_info']['school'] : ''}",
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.width - 36,
                            left: 12,
                            right: 12,
                            child: _information(personalInfo),
                          ),
                        ]),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon:
                                    Image.asset('images/profile/btn_back.png'),
                                onPressed: () {
                                  platformNavigator(context);
                                },
                              ),
                              IconButton(
                                alignment: Alignment.centerRight,
                                icon: widget.otherUserId == null
                                    ? Image.asset(
                                        'images/profile/btn_shezhi.png')
                                    : Image.asset(
                                        'images/profile/btn_more.png'),
                                onPressed: () {
                                  if (personalInfo != null) {
                                    if (widget.otherUserId == null) {
                                      platformNavigator(context,
                                          targetPage: PlatformCmd.SETTING_PAGE);
                                    } else {
                                      _showMoreMenu(personalInfo);
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
            });
      },
    )));
  }

  Widget _actionButton(personalInfo) {
    if (personalInfo != null) {
      if (widget.otherUserId == null) {
        return GestureDetector(
          onTap: () {
            platformStat("30001");
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EditPage();
            }));
          },
          child: Image.asset(
            'images/profile/btn_bianji.png',
            width: 72,
          ),
        );
      } else {
        if (personalInfo['is_friend'] == 0) {
          return GestureDetector(
            onTap: () async {
              // 非好友关系
              var res = await Utils.requestHttp(
                  url: '/friend_operate',
                  data: {'friend_id': widget.otherUserId, 'type': 1},
                  method: 'post',
                  context: context,
                  beforeLoading: true);
              print(res);
              if (res != null) {
                store.dispatch(GetPersonalInfoAction(2, null,
                    offlineUpdate: true, extraKey: 'is_friend'));
              }
            },
            child: Image.asset(
              'images/profile/btn_add.png',
              width: 80,
            ),
          );
        } else if (personalInfo['is_friend'] == 1) {
          return GestureDetector(
            onTap: () async {
              // 好友关系
              platformNavigator(context,
                  targetPage: PlatformCmd.SEND_MSG,
                  arguments: {
                    'otherUserInfo': json.encode(personalInfo['user_info'])
                  });
            },
            child: Image.asset(
              'images/profile/btn_chat.png',
              width: 80,
            ),
          );
        } else if (personalInfo['is_friend'] == 3) {
          return GestureDetector(
            onTap: () async {
              //黑名单关系
              if (personalInfo['initiator_user'] == 1) {
                Utils.showSnackBar(scaffoldCtx,
                    text: "您已将对方拉黑", icon: Icons.info);
              } else if (personalInfo['initiator_user'] == 0) {
                Utils.showSnackBar(scaffoldCtx,
                    text: "您已被对方拉黑", icon: Icons.info);
              }
            },
            child: Image.asset(
              'images/profile/btn_add.png',
              width: 80,
            ),
          );
        } else if (personalInfo['is_friend'] == 2) {
          return Container(
            alignment: Alignment.center,
            width: 80,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '已发送',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          );
        }
      }
    }
    return Container();
  }

  Widget _information(personalInfo) {
    if (personalInfo == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      List<Widget> items = widget.otherUserId == null
          ? [_userValue(personalInfo)]
          : personalInfo['user_status'] == 3
              ? [_goToVisit(personalInfo), _invite(personalInfo)]
              : [_invite(personalInfo)];
      items.addAll([_userHobby(personalInfo), _userMedal(personalInfo)]);

      return DefaultTextStyle(
        style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 24),
        child: Column(
          key: _globalKey,
          children: items,
        ),
      );
    }
  }

  Widget _goToVisit(personalInfo) {
    if (showVisitEntry) {
      return GestureDetector(
        onTap: () async {
          var res = await Utils.requestHttp(
            url: '/search_room',
            data: {'room_name': personalInfo['room']['room_name']},
            method: 'get',
            context: context,
          );
          if (res != null && res['room_name'] != null) {
            platformNavigator(context,
                targetPage: PlatformCmd.GO_ROOM, arguments: {'roomInfo': res});
          } else {
            setState(() {
              showVisitEntry = false;
            });
            Toast.show('Ta已经结束答题了哦', context,
                duration: 2, gravity: Toast.CENTER);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13),
          margin: EdgeInsets.only(bottom: 8),
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/profile/bg_zhengzaidati.png')),
          ),
          child: Row(
            children: <Widget>[
              Utils.placeHolderAvtar(
                  radius: 15,
                  event: false,
                  context: context,
                  placeholder: 'images/common/tongyong_youxiangzhanwei.png',
                  image: Utils.dcImage(personalInfo['user_info']['icon_big'])),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    '正在参与语音Party',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  '去围观',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _invite(personalInfo) {
    if (personalInfo['story'] != null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 104,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/profile/bg_hudong.png')),
        ),
        child: DefaultTextStyle(
          style: TextStyle(fontSize: 13, color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    personalInfo['story']['game_contact'] == 0
                        ? Text('邀请Ta一起嗨皮')
                        : Text(
                            '在同一房间偶遇${personalInfo['story']['game_contact']}次'),
                    personalInfo['story']['gift_contact'] == 0
                        ? Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text('开启你们之间的故事'),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                                '累计礼物互动${personalInfo['story']['gift_contact']}次'),
                          )
                  ]),
              Row(
                children: [
                  Utils.placeHolderAvtar(
                      event: false,
                      context: context,
                      radius: 22,
                      placeholder: 'images/common/tongyong_youxiangzhanwei.png',
                      image: Utils.dcImage(store.state.userInfo['icon_big'])),
                  SizedBox(
                      width: 68,
                      height: 21,
                      child: FlareActor("images/flare/xindiantu.flr",
                          fit: BoxFit.cover, animation: "xindiantu")),
                  Utils.placeHolderAvtar(
                      event: false,
                      context: context,
                      radius: 22,
                      placeholder: 'images/common/tongyong_youxiangzhanwei.png',
                      image:
                          Utils.dcImage(personalInfo['user_info']['icon_big'])),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _userValue(personalInfo) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                personalInfo != null
                    ? '${personalInfo['user_info']['game_win']}'
                    : '0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Show',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1)),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                personalInfo != null
                    ? _formatUnit(personalInfo['user_info']['exp'])
                    : '0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '累计得分',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1)),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                personalInfo != null
                    ? _formatUnit(personalInfo['user_info']['charm'])
                    : '0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '人气值',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(102, 102, 102, 1)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _userHobby(personalInfo) {
    List<Widget> hobbies = [];
    if (personalInfo != null) {
      var memberLabel = personalInfo['user_info']['member_label'];
      for (var i = 0; i < memberLabel.length; i++) {
        var container = Container(
          alignment: Alignment.center,
          height: 29,
          padding: EdgeInsets.symmetric(horizontal: 18),
          margin: EdgeInsets.only(left: i == 0 ? 8 : 12),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(108, 184, 255, 1)),
              color: Color.fromRGBO(108, 184, 255, 0.1),
              borderRadius: BorderRadius.circular(14)),
          child: Text('${memberLabel[i]['name']}'),
        );
        hobbies.add(container);
      }
      if (hobbies.length == 0) {
        var container = Container(
          alignment: Alignment.center,
          height: 29,
          padding: EdgeInsets.symmetric(horizontal: 18),
          margin: EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(108, 184, 255, 1)),
              color: Color.fromRGBO(108, 184, 255, 0.1),
              borderRadius: BorderRadius.circular(14)),
          child: Text('知薯答礼'),
        );
        hobbies.add(container);
      }
    }
    return Container(
      height: 93,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Color.fromRGBO(254, 218, 62, 1),
                radius: 2,
              ),
              Text(
                ' 兴趣爱好',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          DefaultTextStyle(
            style: TextStyle(
                fontSize: 14, color: Color.fromRGBO(108, 184, 255, 1)),
            child: Row(children: hobbies),
          )
        ],
      ),
    );
  }

  Widget _userMedal(personalInfo) {
    List<Widget> medals = [];
    if (personalInfo != null) {
      var finish = personalInfo['finish_achievement'];
      for (var i = 0; i < finish.length; i++) {
        finish[i]['icon'] = finish[i]['icon']
            .replaceAll(RegExp('shutiao/medal'), 'images/medals');
        var container = Container(
          margin: EdgeInsets.only(left: i == 0 ? 8 : 16),
          child: Image.asset(
            finish[i]['state'] != 2
                ? '${finish[i]['icon'].substring(0, finish[i]['icon'].length - 5)}0.png'
                : finish[i]['icon'],
            width: 35,
          ),
        );
        medals.add(container);
      }
    }
    return Container(
      height: 106,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color.fromRGBO(254, 218, 62, 1),
                  radius: 2,
                ),
                Text(
                  ' 成就',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                if (widget.otherUserId == null) {
                  Navigator.pushNamed(context, '/medal');
                }
              },
              child: Container(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: medals,
                ),
              ),
            ),
          ]),
    );
  }

  void _showMoreMenu(personalInfo) {
    overlayMenuEntry = OverlayEntry(builder: (context) {
      return Positioned(
        child: GestureDetector(
          onTap: () {
            overlayMenuEntry.remove();
          },
          child: Container(
            decoration: BoxDecoration(),
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Positioned(
                  top: 70,
                  right: 10,
                  child: Image.asset(
                    personalInfo['is_friend'] == 1
                        ? "images/profile/bg_more.png"
                        : 'images/profile/bg_more2.png',
                    width: 130,
                  ),
                ),
                Positioned(
                  top: 90,
                  right: 10,
                  child: DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 15, color: Color.fromRGBO(102, 102, 102, 1)),
                    child: SizedBox(
                      width: 120,
                      height: 130,
                      child: Column(
                        children: <Widget>[
                          personalInfo['is_friend'] == 1
                              ? GestureDetector(
                                  onTap: () async {
                                    var res = await Utils.requestHttp(
                                        url: '/friend_operate',
                                        data: {
                                          'friend_id': widget.otherUserId,
                                          'type': 2,
                                        },
                                        method: 'post',
                                        context: context,
                                        beforeLoading: true);
                                    if (res != null) {
                                      store.dispatch(GetPersonalInfoAction(
                                          0, null,
                                          offlineUpdate: true,
                                          extraKey: 'is_friend'));
                                    }
                                    overlayMenuEntry.remove();
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '解除好友关系',
                                    ),
                                  ),
                                )
                              : Container(),
                          GestureDetector(
                            onTap: () async {
                              // 黑名单关系
                              if (personalInfo['is_friend'] == 3) {
                                Utils.showSnackBar(scaffoldCtx,
                                    text: '该用户已被拉黑', icon: Icons.info);
                              } else {
                                var res = await Utils.requestHttp(
                                    url: '/friend_operate',
                                    data: {
                                      'friend_id': widget.otherUserId,
                                      'type': 3,
                                    },
                                    method: 'post',
                                    context: context,
                                    beforeLoading: true);
                                if (res != null) {
                                  store.dispatch(GetPersonalInfoAction(0, null,
                                      offlineUpdate: true,
                                      extraKey: 'is_friend'));
                                  Utils.showSnackBar(scaffoldCtx,
                                      text: '拉黑成功，对方将无法给您发送消息',
                                      icon: Icons.info);
                                }
                              }
                              overlayMenuEntry.remove();
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.only(bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '关进小黑屋',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              platformNavigator(context,
                                  targetPage: PlatformCmd.REPORT_PAGE,
                                  arguments: {
                                    'otherUserId': personalInfo['user_info']
                                        ['user_id']
                                  });
                              overlayMenuEntry.remove();
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.only(bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '举报',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
    Overlay.of(context).insert(overlayMenuEntry);
  }

  String _formatUnit(int val) {
    String newVal = '';
    if (val.abs() >= 1000) {
      newVal = (val / 1000).toStringAsFixed(1) + 'k';
    } else if (val.abs() >= 10000) {
      newVal = (val / 10000).toStringAsFixed(1) + 'w';
    } else {
      newVal = val.toString();
    }
    return newVal;
  }
}
