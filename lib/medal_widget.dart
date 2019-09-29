import 'dart:ui';

import 'package:chips_flutter/utils.dart';
import 'package:flutter/material.dart';

class MedalPage extends StatefulWidget {
  @override
  _MedalPageState createState() => _MedalPageState();
}

class _MedalPageState extends State<MedalPage> {
  List<Widget> _elements = [];
  @override
  void initState() {
    super.initState();
    _elements = [];
    Utils.requestHttp(
        url: '/achievement_task_list',
        data: {'type': 1},
        method: "get",
        context: context,
        callback: (json) {
          List<Widget> elements = [];
          for (var item in json) {
            elements.add(_element(item));
          }
          setState(() {
            _elements = elements;
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
          title: Text('我的成就'),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Color.fromRGBO(31, 176, 230, 1),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage('images/medals/bg.png'),
                  fit: BoxFit.cover)),
          child: _buildPage(),
        ),
        backgroundColor: Color.fromRGBO(18, 137, 230, 1),
      ),
    );
  }

  Widget _buildPage() {
    if (_elements.length == 0) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ));
    } else {
      return ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 40, 0.0, 80.0),
            alignment: Alignment.center,
            child: Wrap(spacing: 35.0, runSpacing: 25.0, children: _elements),
          )
        ],
      );
    }
  }

  Widget _element(item) {
    item['icon'] =
        item['icon'].replaceAll(RegExp('shutiao/medal'), 'images/medals');
    return GestureDetector(
        onTap: () {
          _showView(item['catalog_type']);
        },
        child: Column(
          children: <Widget>[
            Image.asset(
              item['state'] != 2
                  ? '${item['icon'].substring(0, item['icon'].length - 5)}0.png'
                  : item['icon'],
              width: 75.0,
              height: 75.0,
            ),
            // FadeInImage.assetNetwork(
            //   width: 75.0,
            //   height: 75.0,
            //   placeholder: 'images/medals/zwt.png',
            //   image: item['state'] != 2
            //       ? Utils.dcImage(
            //           '${item['icon'].substring(0, item['icon'].length - 5)}0.png')
            //       : Utils.dcImage(item['icon']),
            // ),
            Text(
              item['name'],
              style: TextStyle(
                  color: item['state'] != 2
                      ? Color.fromRGBO(4, 105, 162, 1)
                      : Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ));
  }

  void _showView(type) async {
    var res = await Utils.requestHttp(
        url: '/achievement_type_list',
        data: {'type': type},
        method: 'get',
        context: context,
        beforeLoading: true);
    if (res != null) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return ViewDialog(res: res);
          });
    }
  }
}

class ViewDialog extends StatefulWidget {
  ViewDialog({Key key, this.res}) : super(key: key);
  final res;
  @override
  _ViewDialogState createState() => _ViewDialogState(res);
}

class _ViewDialogState extends State<ViewDialog> {
  var clickNum = 1;
  _ViewDialogState(res) {
    if (res['level'] == 1 || res['level'] == 0) {
      clickNum = 1;
    } else {
      clickNum = res['level'];
    }
  }
  @override
  Widget build(BuildContext context) {
    var items = widget.res;
    // 读取本地勋章地址
    items['list'][0]['icon'] = items['list'][0]['icon']
        .replaceAll(RegExp('shutiao/medal'), 'images/medals');
    items['list'][1]['icon'] = items['list'][1]['icon']
        .replaceAll(RegExp('shutiao/medal'), 'images/medals');
    items['list'][2]['icon'] = items['list'][2]['icon']
        .replaceAll(RegExp('shutiao/medal'), 'images/medals');
    var placeHolderIndex =
        items['list'][clickNum - 1]['desc'].indexOf("@") != -1
            ? items['list'][clickNum - 1]['desc'].indexOf("@")
            : items['list'][clickNum - 1]['desc'].length;
    var progress = items['list'][clickNum - 1]['progress'];
    progress = progress <= items['list'][clickNum - 1]['goal']
        ? '$progress'
        : '${items['list'][clickNum - 1]['goal']}';
    if (items['list'][clickNum - 1]['desc'].indexOf("@") == -1) {
      progress = '';
    }
    void _handleClick(num) {
      setState(() {
        clickNum = num;
      });
    }

    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 500.0,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
            'images/medals/honour_bg.png',
          ))),
          child: Column(
            children: <Widget>[
              Container(
                height: 180.0,
                width: 320,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Image.asset('images/medals/honour_icon_tape$clickNum.png'),
                    Positioned(
                      top: 54.0,
                      child: Image.asset(
                        items['list'][clickNum - 1]['icon'],
                        width: 100.0,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Positioned(
                      child: GestureDetector(
                        child: Image.asset('images/common/icon_close.png',
                            fit: BoxFit.fitWidth, width: 20.0),
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                      right: 0.0,
                      top: 10.0,
                    ),
                  ],
                ),
              ),
              Image.network(
                Utils.dcImage(items['alias_name']),
                width: 90.0,
              ),
              Container(
                  width: 300.0,
                  margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
                  child: DefaultTextStyle(
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(100, 100, 100, 1),
                        fontSize: 17.0,
                        decoration: TextDecoration.none),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: items['list'][clickNum - 1]['desc']
                              .substring(0, placeHolderIndex),
                        ),
                        TextSpan(
                          text: '$progress',
                          style: TextStyle(
                            color: Color.fromRGBO(246, 215, 88, 1),
                          ),
                        ),
                        TextSpan(
                          text: placeHolderIndex <
                                  items['list'][clickNum - 1]['desc'].length
                              ? items['list'][clickNum - 1]['desc']
                                  .substring(placeHolderIndex + 1)
                              : '',
                        )
                      ]),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '奖励 ',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromRGBO(100, 100, 100, 1),
                        decoration: TextDecoration.none),
                  ),
                  Image.asset(
                    'images/medals/honour_icon_st.png',
                    width: 25.0,
                  ),
                  Text(
                    ' x${items['list'][clickNum - 1]['gold']}',
                    style: TextStyle(
                        wordSpacing: -3,
                        fontSize: 16.0,
                        color: Color.fromRGBO(100, 100, 100, 1),
                        decoration: TextDecoration.none),
                  )
                ],
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 50.0),
                width: 300.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Image(
                        image: ExactAssetImage(
                            items['list'][0]['state'] != 2
                                ? '${items['list'][0]['icon'].substring(0, items['list'][0]['icon'].length - 5)}0.png'
                                : items['list'][0]['icon'],
                            scale: clickNum == 1 ? 7.0 : 9.0),
                      ),
                      onTap: () {
                        _handleClick(1);
                      },
                    ),
                    Image(
                      image: ExactAssetImage(
                          'images/medals/honour_icon_Arrow.png',
                          scale: 2.0),
                    ),
                    GestureDetector(
                      child: Image(
                        image: ExactAssetImage(
                            items['list'][1]['state'] != 2
                                ? '${items['list'][1]['icon'].substring(0, items['list'][1]['icon'].length - 5)}0.png'
                                : items['list'][1]['icon'],
                            scale: clickNum == 2 ? 7.0 : 9.0),
                      ),
                      onTap: () {
                        _handleClick(2);
                      },
                    ),
                    Image(
                      image: ExactAssetImage(
                          'images/medals/honour_icon_Arrow.png',
                          scale: 2.0),
                    ),
                    GestureDetector(
                      child: Image(
                        image: ExactAssetImage(
                            items['list'][2]['state'] != 2
                                ? '${items['list'][2]['icon'].substring(0, items['list'][2]['icon'].length - 5)}0.png'
                                : items['list'][2]['icon'],
                            scale: clickNum == 3 ? 7.0 : 9.0),
                      ),
                      onTap: () {
                        _handleClick(3);
                      },
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
