import 'package:chips_flutter/utils.dart';
import 'package:flutter/material.dart';

class RankOverView extends StatefulWidget {
  @override
  _RankOverViewState createState() => _RankOverViewState();
}

class _RankOverViewState extends State<RankOverView> {
  var popularData;
  var pointsData;
  @override
  void initState() {
    super.initState();
    Utils.requestHttp(
        url: '/leaderboards',
        context: context,
        method: 'get',
        callback: (json) {
          setState(() {
            pointsData = json['shutiao_lbGameScore']['total_list'];
            popularData = json['shutiao_lbGameCharm']['total_list'];
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
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: const BackButtonIcon(),
              color: Colors.black,
              // tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                platformNavigator(context);
              }),
          title: Text(
            '排行榜',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: _buildPage(),
      ),
    );
  }

  Widget _buildPage() {
    if (popularData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(children: <Widget>[_popularity(), _points()]);
    }
  }

  Widget _popularity() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Image.asset(
            'images/rank/phb_renqi_bg1.png',
            width: 350,
          ),
          Positioned(
            top: 18,
            right: 10,
            child: GestureDetector(
                onTap: () {
                  _toRank(2);
                },
                child: Container(
                  color: Colors.transparent,
                  width: 200,
                  height: 30,
                )),
          ),
          Positioned(
            child: Column(
              children: _getItems(popularData, '人气值'),
            ),
          )
        ],
      ),
    );
  }


  Widget _points() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Image.asset(
            'images/rank/phb_jifen_bg1.png',
            width: 350,
          ),
          Positioned(
              top: 18,
              right: 10,
              child: GestureDetector(
                  onTap: () {
                    _toRank(1);
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: 200,
                    height: 30,
                  ))),
          Positioned(
            child: Column(
              children: _getItems(pointsData, '积分值'),
            ),
          )
        ],
      ),
    );
  }


  List<Widget> _getItems(lists, title) {
    List<Widget> items = [];
    for (var index = 0; index < lists.length; index++) {
      var item = Container(
        width: 350,
        height: 63,
        margin: index == 0 ? EdgeInsets.only(top: 55) : EdgeInsets.only(top: 0),
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "images/rank/multiple_ranking_${index + 1}.png",
                width: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Utils.placeHolderAvtar(
                    placeholder: 'images/common/tongyong_youxiangzhanwei.png',
                    image: Utils.dcImage(lists[index]['icon_big']),
                    userId: lists[index]['user_id'] ==
                            store.state.userInfo['user_id']
                        ? null
                        : lists[index]['user_id'],
                    context: context),
              )
            ],
          ),
          title: Text('${lists[index]['nickname']}'),
          subtitle: Text('$title${lists[index]['rank_score']}'),
        ),
      );
      items.add(item);
    }
    return items;
  }

  // 1->积分榜 2->人气榜 3->高校榜 4->出题榜 5->答对榜
  void _toRank(rankType) {
    if(rankType == 2){
      platformStat("3001");
    }else if(rankType ==1){
      platformStat("3002");
    }
    Navigator.pushNamed(context, '/rank/details',
        arguments: {'rankType': rankType});
  }
}
