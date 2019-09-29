import 'dart:ui';

import 'package:chips_flutter/app_state.dart';
import 'package:chips_flutter/profile_widget.dart';
import 'package:chips_flutter/rank_widget.dart';
import 'package:chips_flutter/redux_actions.dart';
import 'package:chips_flutter/tabbarDemo.dart';
import 'package:chips_flutter/utils.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:chips_flutter/medal_widget.dart';
import 'package:chips_flutter/rank_Overview.dart';
import 'package:chips_flutter/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'feedback_widget.dart';

// void main() => runApp(MyApp(store: store));
Widget rootWidget;
void main() {
  if (window.defaultRouteName.indexOf(":") != -1) {
    var splitParams = window.defaultRouteName.split(':');
    switch (splitParams[0]) {
      case '/profile':
        rootWidget = _prepare(ProfilePage(otherUserId: splitParams[1]));
        break;
      default:
    }
  } else {
    rootWidget = InitPage();
  }
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  final Map<String, Function> dynamicRoutes = {
    "/rank/details": (context, {arguments}) => RankPage(arguments: arguments),
    "/profile/otherUser": (context, {arguments}) =>
        ProfilePage(otherUserId: arguments['otherUserId'])
  };

  MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
          const Locale('en', 'US'),
        ],
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        title: '薯条',
        theme: ThemeData(
          platform: TargetPlatform.android,
          primarySwatch: Colors.blue,
        ),
        initialRoute: window.defaultRouteName,
        home: rootWidget,
        routes: {
          // "/": (context) {
          //   return InitPage();
          // },
          "/task": (context) => _prepare(TaskPage()),
          "/medal": (context) => _prepare(MedalPage()),
          "/feedback": (context) => _prepare(FeedbackPage()),
          // "/rank": (context) => _prepare(RankOverView()),
          "/rank": (context) => TabbedAppBarSample(),
          "/profile": (context) => _prepare(ProfilePage()),
          "/rank/points": (context) =>
              _prepare(RankPage(arguments: {'rankType': 1})),
          "/rank/popular": (context) =>
              _prepare(RankPage(arguments: {'rankType': 2})),
          "/rank/school": (context) =>
              _prepare(RankPage(arguments: {'rankType': 3}))
        },
        navigatorObservers: [NewObserve()],
        onGenerateRoute: (RouteSettings settings) {
          final String name = settings.name;
          final Function pageContentBuilder = this.dynamicRoutes[name];
          if (pageContentBuilder != null) {
            final Route route = MaterialPageRoute(
                builder: (context) =>
                    pageContentBuilder(context, arguments: settings.arguments));
            return route;
          }
          return null;
        },
      ),
    );
  }
}

Widget _prepare(Widget widget) {
  return StoreConnector<AppState, dynamic>(
    converter: (store) => store.state.userInfo,
    builder: (context, userInfo) {
      if (userInfo == null) {
        Utils.platformContxt = context;
        store.dispatch(GetUserInfoAction);
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return widget;
      }
    },
  );
}

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        spacing: 10,
        children: <Widget>[
          RaisedButton(
            child: Text('任务'),
            onPressed: () {
              Navigator.pushNamed(context, '/task');
            },
          ),
          RaisedButton(
            child: Text('成就'),
            onPressed: () {
              Navigator.pushNamed(context, '/medal');
            },
          ),
          RaisedButton(
            child: Text('排行榜'),
            onPressed: () {
              Navigator.pushNamed(context, '/rank');
            },
          ),
          RaisedButton(
            child: Text('个人信息'),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          RaisedButton(
            child: Text('意见反馈'),
            onPressed: () {
              Navigator.pushNamed(context, '/feedback');
            },
          )
        ],
      ),
    );
  }
}

class NewObserve extends NavigatorObserver {
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null &&
        window.defaultRouteName.contains(route.settings.name) &&
        window.defaultRouteName != '/') {
      Utils.isRootPage = true;
    } else {
      Utils.isRootPage = false;
    }
    // 当调用Navigator.push时回调
    //可通过route.settings获取路由相关内容
    print("isRoot: " + Utils.isRootPage.toString());
    print('push: ${window.defaultRouteName}');
    print(route.settings);
    print(previousRoute);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute.settings.name != null &&
        window.defaultRouteName.contains(previousRoute.settings.name) &&
        window.defaultRouteName != '/') {
      Utils.isRootPage = true;
    } else {
      Utils.isRootPage = false;
    }
    print("isRoot: " + Utils.isRootPage.toString());
    print('pop: ${window.defaultRouteName}');
    // 当调用Navigator.pop时回调
    print(route);
    //route.currentResult获取返回内容
    print(previousRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    // 当调用Navigator.Remove时回调
    super.didRemove(route, previousRoute);
    print(route);
    print(previousRoute);
  }
}
