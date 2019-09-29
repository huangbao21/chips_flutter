import 'dart:convert';
import 'dart:ui';
import 'package:chips_flutter/app_state.dart';
import 'package:chips_flutter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List items = [];
  @override
  void initState() {
    super.initState();
    Utils.requestHttp(
        url: '/achievement_task_list',
        data: {'type': 2},
        method: 'get',
        context: context,
        callback: (json) {
          setState(() {
            items = json;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await platformNavigator(context);
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const BackButtonIcon(),
                color: Colors.white,
                // tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () {
                  platformNavigator(context);
                }),
            title: Text(
              '任务',
            ),
            centerTitle: true,
          ),
          body: _buildPage()),
    );
  }

  Widget _buildPage() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        return _buildTask(items[i]);
      },
    );
  }

  Widget _buildTask(task) {
    var placeHolderIndex = task['desc'].indexOf("@") != -1
        ? task['desc'].indexOf("@")
        : task['desc'].length;
    var progress = task['progress'];
    progress = progress <= task['goal']
        ? progress.toString()
        : task['goal'].toString();
    if (task['desc'].indexOf("@") == -1) {
      progress = '';
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(20.0)),
          border: Border.all(width: 2.0, color: Colors.grey[300])),
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10.0),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/common/tongyong_youxiangzhanwei.png',
                image: Utils.dcImage(task['icon']),
                width: 50.0,
                height: 50.0,
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text(
                    '${task['name']}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[500],
                  ),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: task['desc'].substring(0, placeHolderIndex)),
                    TextSpan(
                        text: progress,
                        style: TextStyle(
                          color: Color.fromRGBO(246, 215, 88, 1),
                        )),
                    TextSpan(
                        text: placeHolderIndex < task['desc'].length
                            ? task['desc'].substring(placeHolderIndex + 1)
                            : '')
                  ])),
                )
              ],
            ),
          ),
          Container(
            width: 60.0,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Image.asset(
                'images/medals/honour_icon_st.png',
                width: 20.0,
              ),
              Text(' X ${task['gold']}')
            ]),
          ),
          GestureDetector(
              onTap: () {
                _tailButtonAction(task);
              },
              child: _tailButton(task))
        ],
      ),
    );
  }

  Widget _tailButton(task) {
    var _style = {
      'color': Colors.blue[500],
      'boderColor': Colors.blue[700],
      'text': '去完成',
      'textColor': Colors.white
    };
    if (task['state'] == 1) {
      _style['color'] = Color(0xffffdf5a);
      _style['boderColor'] = Color(0xff852f00);
      _style['text'] = '领取';
      _style['textColor'] = Color(0xff852f00);
    } else if (task['state'] == 2) {
      _style['color'] = Color.fromRGBO(27, 188, 65, 1);
      _style['boderColor'] = Color.fromRGBO(26, 146, 6, 1);
      _style['text'] = '已完成';
      _style['textColor'] = Colors.white;
    }
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      width: 70.0,
      decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: _style['boderColor']),
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
          color: _style['color']),
      // width: 50.0,
      padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: Text(
        _style['text'],
        style: TextStyle(
            color: _style['textColor'],
            fontWeight: FontWeight.bold,
            fontSize: 15.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _tailButtonAction(task) {
    if (task['state'] == 1) {
      _awardDialog(task);
    } else if (task['state'] == 0) {
      if (task['jump_type'] == 1) {
        // 跳转到首页
        platformNavigator(context);
      } else if (task['jump_type'] == 2) {
        // 打开分享dialog
        _shareDialog(task);
      } else if (task['jump_type'] == 4) {
        // 个人匹配
        platformNavigator(context,
            targetPage: PlatformCmd.GAME_MATCH, arguments: {'startGame': 1});
      } else if (task['jump_type'] == 5) {
        //组队匹配
        platformNavigator(context,
            targetPage: PlatformCmd.GAME_MATCH, arguments: {'startGame': 2});
      }
    } else {}
  }

  void _updateShareTaskState(res, task) {
    res = json.decode(res);
    if (res['state'] == 1) {
      setState(() {
        task['state'] = 1;
      });
    }
  }

// 分享窗口
  void _shareDialog(task) async {
    var json = await Utils.requestHttp(
        url: '/share_action',
        data: {'share_type': 3},
        method: 'get',
        context: context,
        beforeLoading: true);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Container(
                child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      // color: Colors.red,
                      height: 40.0,
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                            // color: Colors.yellow,
                            image: DecorationImage(
                                image: NetworkImage(Utils.dcImage(
                                    Utils.getRandomDataInList(
                                        json['share_icon'])))),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        width: 270.0,
                        height: 480.0,
                      )),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.86),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0))),
                    height: 113.0,
                    child: DefaultTextStyle(
                      style: TextStyle(
                          fontSize: 13.0,
                          decoration: TextDecoration.none,
                          height: 1.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              platformShare(context, PlatformCmd.SHARE_WX).then(
                                  (res) => _updateShareTaskState(res, task));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'images/share/icon-wechat.png'),
                                  radius: 25,
                                ),
                                Text('微信'),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              platformShare(
                                      context, PlatformCmd.SHARE_WX_MOMENTS)
                                  .then((res) =>
                                      _updateShareTaskState(res, task));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'images/share/icon_circleoffriends.png'),
                                  radius: 25,
                                ),
                                Text('朋友圈'),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              platformShare(context, PlatformCmd.SHARE_QQ).then(
                                  (res) => _updateShareTaskState(res, task));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('images/share/icon_QQ.png'),
                                  radius: 25,
                                ),
                                Text('QQ'),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              platformShare(context, PlatformCmd.SHARE_QZONE)
                                  .then((res) =>
                                      _updateShareTaskState(res, task));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('images/share/icon_QQKJ.png'),
                                  radius: 25,
                                ),
                                Text('QQ空间'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            )),
          );
        });
  }

// 奖励弹窗
  void _awardDialog(task) async {
    var json = await Utils.requestHttp(
        url: '/achievement_task_notice',
        data: {'taskId': task['catalog_type'], 'type': 2},
        method: 'post',
        context: context,
        beforeLoading: true);
    if (json != null) {
      setState(() {
        task['state'] = 2;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              contentPadding: EdgeInsets.only(top: 50.0, bottom: 50.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '恭喜你获得奖励',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: CircleAvatar(
                        radius: 31.0,
                        backgroundColor: Colors.grey[300],
                        child: CircleAvatar(
                          child: Image.asset(
                            'images/medals/honour_icon_st.png',
                            width: 30.0,
                            fit: BoxFit.fitWidth,
                          ),
                          radius: 30.0,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '薯条x${json[0]['reward']}',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                    ),
                  ],
                )
              ],
            );
          });
    }
  }
}
