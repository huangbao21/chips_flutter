import 'dart:ui';

import 'package:chips_flutter/app_state.dart';
import 'package:chips_flutter/redux_actions.dart';
import 'package:chips_flutter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RankPage extends StatefulWidget {
  RankPage({Key key, this.arguments}) : super(key: key);
  final Map arguments;

  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage>
    with SingleTickerProviderStateMixin {
  List<Tab> titleTabs = [];
  List<Widget> tabView = [];
  TabController tabController;
  int bgColor;
  int tabLblColor;
  String rankImag = '';
  String barImag = '';

  @override
  void initState() {
    super.initState();

    setSpecificStyle(widget.arguments['rankType']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color(bgColor),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/rank/phb_bg_guang.png'))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: () {
                  _ruleDialog();
                },
              )
            ],
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: TabBar(
              controller: tabController,
              isScrollable: true,
              unselectedLabelColor: Color(tabLblColor),
              // unselectedLabelColor: Color(tabLblColor),
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(style: BorderStyle.none)),
              indicatorColor: Colors.red,
              tabs: titleTabs,
            ),
          ),
          body: Container(
            child: TabBarView(controller: tabController, children: tabView),
          ),
        ));
  }

  void setSpecificStyle(rankType) {
    if (rankType == 1) {
      // 积分榜
      tabLblColor = 0xffab3650;
      bgColor = 0xffff6a79;
      rankImag = 'images/rank/phb_jifen_123.png';
      barImag = 'images/rank/phb_jifen_xiankuang.png';
      titleTabs = <Tab>[
        Tab(text: '总榜'),
        Tab(
          text: '今日实时榜',
        ),
        Tab(
          text: '昨日榜',
        ),
        Tab(
          text: '周总榜',
        ),
      ];
      tabView = <Widget>[
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.allRankList,
          builder: (context, allList) {
            return _rankData(allList);
          },
        ),
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.todayRankList,
          builder: (context, todayList) {
            return _rankData(todayList);
          },
        ),
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.yesterdayRankList,
          builder: (context, yesterdayRankList) {
            return _rankData(yesterdayRankList);
          },
        ),
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.lastRankList,
          builder: (context, lastRankList) {
            return _rankData(lastRankList);
          },
        ),
      ];
      tabController = TabController(vsync: this, length: titleTabs.length)
        ..addListener(() {
          if (tabController.index.toDouble() == tabController.animation.value) {
            switch (tabController.index) {
              case 0:
                store.dispatch(RankListAction(rankType, rankTime: 'all'));
                break;
              case 1:
                store.dispatch(RankListAction(rankType, rankTime: 'today'));
                break;
              case 2:
                store.dispatch(RankListAction(rankType, rankTime: 'yesterday'));
                break;
              case 3:
                store.dispatch(RankListAction(rankType, rankTime: 'lastweek'));
                break;
            }
          }
        });
    } else if (rankType == 2) {
      // 人气榜
      tabLblColor = 0xffa34b34;
      bgColor = 0xffff926a;
      rankImag = 'images/rank/phb_renqi_123.png';
      barImag = 'images/rank/phb_renqi_xiankuang.png';
      titleTabs = <Tab>[
        Tab(text: '人气总榜'),
        Tab(
          text: '今日实时榜',
        ),
        Tab(
          text: '昨日榜',
        ),
        Tab(
          text: '周总榜',
        ),
      ];
      tabView = <Widget>[
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.allRankList,
          builder: (context, allList) {
            return _rankData(allList);
          },
        ),
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.todayRankList,
          builder: (context, todayList) {
            return _rankData(todayList);
          },
        ),
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.yesterdayRankList,
          builder: (context, yesterdayRankList) {
            return _rankData(yesterdayRankList);
          },
        ),
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.lastRankList,
          builder: (context, lastRankList) {
            return _rankData(lastRankList);
          },
        ),
      ];
      tabController = TabController(vsync: this, length: titleTabs.length)
        ..addListener(() {
          if (tabController.index.toDouble() == tabController.animation.value) {
            switch (tabController.index) {
              case 0:
                store.dispatch(RankListAction(rankType, rankTime: 'all'));
                break;
              case 1:
                store.dispatch(RankListAction(rankType, rankTime: 'today'));
                break;
              case 2:
                store.dispatch(RankListAction(rankType, rankTime: 'yesterday'));
                break;
              case 3:
                store.dispatch(RankListAction(rankType, rankTime: 'lastweek'));
                break;
            }
          }
        });
    } else if (rankType == 3) {
      // 高校榜
      tabLblColor = 0xff5d4aa2;
      bgColor = 0xffa179f0;
      rankImag = 'images/rank/phb_gaoxiao_123.png';
      barImag = 'images/rank/phb_gaoxiao_xiankuang.png';
      titleTabs = <Tab>[
        Tab(text: '总榜'),
        Tab(
          text: '今日实时榜',
        ),
        Tab(
          text: '昨日榜',
        ),
        Tab(
          text: '周总榜',
        ),
      ];
      tabView = <Widget>[
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.allRankList,
          builder: (context, allList) {
            return _rankData(allList);
          },
        ),
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.todayRankList,
          builder: (context, todayList) {
            return _rankData(todayList);
          },
        ),
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.yesterdayRankList,
          builder: (context, yesterdayRankList) {
            return _rankData(yesterdayRankList);
          },
        ),
        StoreConnector<AppState, dynamic>(
          converter: (store) => store.state.lastRankList,
          builder: (context, lastRankList) {
            return _rankData(lastRankList);
          },
        ),
      ];
      tabController = TabController(vsync: this, length: titleTabs.length)
        ..addListener(() {
          if (tabController.index.toDouble() == tabController.animation.value) {
            switch (tabController.index) {
              case 0:
                store.dispatch(RankListAction(rankType, rankTime: 'all'));
                break;
              case 1:
                store.dispatch(RankListAction(rankType, rankTime: 'today'));
                break;
              case 2:
                store.dispatch(RankListAction(rankType, rankTime: 'yesterday'));
                break;
              case 3:
                store.dispatch(RankListAction(rankType, rankTime: 'lastweek'));
                break;
            }
          }
        });
    } else if (rankType == 4) {
      //出题榜
      tabLblColor = 0xff36408d;
      bgColor = 0xff6a85ff;
      rankImag = 'images/rank/phb_chuti_123.png';
      barImag = 'images/rank/phb_chuti_xiankuang.png';
    }
    tabController.index = 1;
  }

  // 1->积分榜 2->人气榜 3->高校榜 4->出题榜 5-> 答对榜
  List<Widget> _getRuleInfo(rankType) {
    if (rankType == 1) {
      return <Widget>[
        Text('今日实时榜', style: TextStyle(color: Colors.black)),
        Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text('今日新增积分前100名玩家，将登上排行榜，每日00:00重置榜单')),
        Text('昨日榜', style: TextStyle(color: Colors.black)),
        Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text('截止当日00:00，前一日累计新增积分前100名玩家将登上昨日榜')),
        Text('积分总榜', style: TextStyle(color: Colors.black)),
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Text('累计积分前100名将登上排行榜'),
        ),
        Text('周总榜', style: TextStyle(color: Colors.black)),
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Text('上周新增积分前100名，将登上周总榜，周一00：00重置榜单'),
        ),
      ];
    } else if (rankType == 2) {
      return <Widget>[
        Text('今日实时榜', style: TextStyle(color: Colors.black)),
        Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text('今日新增人气前100名玩家，将登上排行榜，每日00:00重置榜单')),
        Text('昨日榜', style: TextStyle(color: Colors.black)),
        Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text('截止当日00:00，前一日累计新增人气前100名玩家将登上昨日榜')),
        Text('人气总榜', style: TextStyle(color: Colors.black)),
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Text('累计人气前100名将登上排行榜'),
        ),
        Text('周总榜', style: TextStyle(color: Colors.black)),
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Text('上周新增人气前100名，将登上周总榜，周一00：00重置榜单'),
        ),
      ];
    } else if (rankType == 3) {
      return <Widget>[
        Text('今日实时榜', style: TextStyle(color: Colors.black)),
        Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text('今日各高校用户新增积分总和前100名玩家，将登上排行榜，每日00:00重置榜单')),
        Text('昨日榜', style: TextStyle(color: Colors.black)),
        Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text('截止当日00:00，前一日各高校用户新增积分总和前100名玩家将登上昨日榜')),
        Text('高校积分总榜', style: TextStyle(color: Colors.black)),
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Text('各高校用户积分总和前100名将登上排行榜'),
        ),
        Text('周总榜', style: TextStyle(color: Colors.black)),
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Text('上周各高校用户新增积分总和前100名，将登上周总榜，周一00：00重置榜单'),
        ),
      ];
    } else {
      return <Widget>[
        Text('总榜', style: TextStyle(color: Colors.black)),
        Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text('累计出题数量前100名将登上排行榜')),
        Text('周总榜', style: TextStyle(color: Colors.black)),
        Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text('上周新增出题数量前100名，将登上周总榜，周一00：00重置榜单')),
      ];
    }
  }

// 规则弹框
  void _ruleDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DefaultTextStyle(
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  decoration: TextDecoration.none),
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  height: 400,
                  width: 300,
                  padding: EdgeInsets.only(left: 40, right: 15, top: 15),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.topLeft,
                          image: ExactAssetImage('images/rank/tishi_diwen.png',
                              scale: 2.0)),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ListView(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Image.asset(
                              'images/common/icon_close.png',
                              width: 20,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            '排行规则',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _getRuleInfo(widget.arguments['rankType']),
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  Widget _rankData(listData) {
    if (listData == null) {
      return Center(child: CircularProgressIndicator());
    } else if (listData['total_list'].length == 0) {
      return _defaultContent();
    } else {
      var own = listData;
      listData = own['total_list'];
      return Container(
        child: Column(children: [
          Container(
            width: double.infinity,
            height: 238,
            child: Stack(
                alignment: Alignment.topCenter, children: _topThree(listData)),
          ),
          Expanded(
              child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                left: 10,
                right: 10,
                child: Image.asset(barImag),
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                  margin: EdgeInsets.fromLTRB(15.0, 5, 15.0, 0),
                  child: _listRank(listData, own['user_id']))
            ],
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Color.fromRGBO(35, 35, 35, 1), width: 1)),
                  color: Color.fromRGBO(255, 213, 89, 1)),
              height: 50.0,
              child: _ownRank(own),
            ),
          )
        ]),
      );
    }
  }

  Widget _ownRank(own) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 32.0),
          child: Text(
            own['rank'] == -1 ? '未上榜' : '${own['rank']}',
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 20.0, right: 10.0),
            child: Utils.placeHolderAvtar(
                context: context,
                placeholder: 'images/common/tongyong_youxiangzhanwei.png',
                image: Utils.dcImage(own['icon_big']))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${own['nickname']}',
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.0, color: Colors.black),
              ),
              Text(
                '${own['school']}',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.0, color: Colors.black),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 30.0, left: 10.0),
          child: Text(
            ' ${own['rank_score']} ',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18.0),
          ),
        ),
      ],
    );
  }

  Widget _listRank(list, ownId) {
    return ListView.builder(
      itemCount: list.length - 3,
      itemExtent: 60.0,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Row(
            children: <Widget>[
              Text('${list[i + 3]['rank']}'),
              Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Utils.placeHolderAvtar(
                      context: context,
                      placeholder: 'images/common/tongyong_youxiangzhanwei.png',
                      image: Utils.dcImage(list[i + 3]['icon_big']),
                      userId: list[i + 3]['user_id'] ==
                              store.state.userInfo['user_id']
                          ? null
                          : list[i + 3]['user_id']))
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          title: Text(
            '${list[i + 3]['nickname']}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          subtitle: Text(
            '${list[i + 3]['school']}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.0),
          ),
          trailing: Text(
            '${list[i + 3]['rank_score']}',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
        );
      },
    );
  }

  Widget _defaultContent() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/common/tongyongqueshengtu_blue.png.png',
          width: 150.0,
        ),
        Text(
          '榜上无人，快去参与答题冲榜啦！',
          style: TextStyle(
              color: Color.fromRGBO(206, 236, 255, 1), fontSize: 20.0),
        ),
      ],
    ));
  }

  List<Widget> _topThree(listData) {
    List<Widget> topThree = [];
    topThree.add(Positioned(
      child: Image.asset(rankImag),
      left: 32,
      right: 32,
      top: 130,
    ));
    topThree.add(_firstAvtar(listData));
    if (listData.length > 1) {
      topThree.add(_secondAvtar(listData));
    }
    if (listData.length > 2) {
      topThree.add(_thirdAvtar(listData));
    }
    return topThree;
  }

  Widget _firstAvtar(list) {
    var item = list[0];
    return Positioned(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            child: Utils.placeHolderAvtar(
                context: context,
                placeholder: 'images/common/tongyong_youxiangzhanwei.png',
                image: Utils.dcImage(
                  item['icon_big'],
                ),
                radius: 32,
                userId: item['user_id'] == store.state.userInfo['user_id']
                    ? null
                    : item['user_id']),
            radius: 35,
            backgroundImage:
                AssetImage('images/rank/phb_touxiangkuang_jin.png'),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            width: 100.0,
            child: Text(
              '${item['nickname']}',
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          SizedBox(
            width: 100.0,
            child: Text(
              '${item['school']}',
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          SizedBox(
            width: 100.0,
            child: Text(
              '${item['rank_score']}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _secondAvtar(list) {
    var item = list[1];
    return Positioned(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            child: Utils.placeHolderAvtar(
                context: context,
                placeholder: 'images/common/tongyong_youxiangzhanwei.png',
                image: Utils.dcImage(
                  item['icon_big'],
                ),
                radius: 27,
                userId: item['user_id'] == store.state.userInfo['user_id']
                    ? null
                    : item['user_id']),
            backgroundImage:
                AssetImage('images/rank/phb_touxiangkuang_yin.png'),
            backgroundColor: Colors.transparent,
            radius: 30,
          ),
          SizedBox(
            width: 100.0,
            child: Text(
              '${item['nickname']}',
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          SizedBox(
            width: 100.0,
            child: Text(
              '${item['school']}',
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          SizedBox(
            width: 100.0,
            child: Text(
              '${item['rank_score']}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
        ],
      ),
      top: 40.0,
      left: 32,
    );
  }

  Widget _thirdAvtar(list) {
    var item = list[2];
    return Positioned(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            child: Utils.placeHolderAvtar(
                context: context,
                placeholder: 'images/common/tongyong_youxiangzhanwei.png',
                image: Utils.dcImage(
                  item['icon_big'],
                ),
                radius: 27,
                userId: item['user_id'] == store.state.userInfo['user_id']
                    ? null
                    : item['user_id']),
            backgroundImage:
                AssetImage('images/rank/phb_touxiangkuang_tong.png'),
            backgroundColor: Colors.transparent,
            radius: 30,
          ),
          SizedBox(
            width: 100.0,
            child: Text(
              '${item['nickname']}',
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          SizedBox(
            width: 100.0,
            child: Text(
              '${item['school']}',
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          SizedBox(
            width: 100.0,
            child: Text(
              '${item['rank_score']}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
        ],
      ),
      top: 45.0,
      right: 32,
    );
  }
}
