import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;

import 'package:chips_flutter/AESUtil.dart';
import 'package:chips_flutter/app_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:toast/toast.dart';

const platform = const MethodChannel('flutter.io/message');

final store = Store<AppState>(appReducer,
    initialState: AppState.initState(),
    middleware: [middleware, rankMiddleware]);

class PlatformCmd {
  static const String NAVIGATOR_POP = "pop";
  static const String SHARE_WX = "wx";
  static const String SHARE_WX_MOMENTS = "wx_moments";
  static const String SHARE_QZONE = "qzone";
  static const String SHARE_QQ = "qq";
  static const String GET_INFO = "get_info";
  static const String USER_INFO_DIALOG = "user_info_dialog";
  static const String SETTING_PAGE = "setting_page";
  static const String EDIT_PAGE = "edit_page";
  static const String GO_ROOM = "go_room";
  static const String GAME_MATCH = "game_match";
  static const String SEND_MSG = "send_msg";
  static const String CHANGE_SCHOOL = "change_school";
  static const String EDIT_AVATAR = "edit_avatar";
  static const String REPORT_PAGE = "report_page";
  static const String EVENT_STATIS = "event_statis";
}

class Utils {
  static String assetsUrl = 'https://res.xingqiu123.com/';
  static String baseUrl = 'http://47.99.67.125:8081/Shutiao/';
  static String token = '';
  static BuildContext platformContxt;
  static bool isRootPage = false;
  static requestHttp({
    @required String url,
    Map data,
    @required String method,
    @required BuildContext context,
    callback,
    bool beforeLoading = false,
  }) async {
    String aesKey = 'paopao46c87p85ic';
    data ??= {};
    data['user_token'] = token;
    var requestParams = {
      'params': AESUtil.encrypt2Base64(aesKey, json.encode(data))
    };

    Dio dio = new Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 10000,
        receiveTimeout: 10000,
        contentType: ContentType.parse("application/x-www-form-urlencoded")));

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      if (beforeLoading) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  width: 50.0,
                  height: 50.0,
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white));
            });
      }
      print("url " + options.baseUrl + options.path);
      print("token " + token);
      return options;
    }, onResponse: (Response response) {
      if (beforeLoading) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (callback != null) {
        var res = json.decode(response.data);
        print(AESUtil.decrypt2Base64(aesKey, res['encrypt_value']));
        if (res['code'] == 200) {
          callback(AESUtil.decrypt2Base64(aesKey, res['encrypt_value']));
        } else {
          Toast.show(res['message'], context, duration: Toast.LENGTH_SHORT);
        }
      }
      return response;
    }, onError: (DioError e) {
      print("ERROR: $e");
      Toast.show("网络异常", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return e;
    }));
    var response;
    if (method.toLowerCase() == 'post') {
      response = await dio.post(url, data: requestParams);
    } else if (method.toLowerCase() == 'get') {
      response = await dio.get(url, queryParameters: requestParams);
    }
    var res = json.decode(response.data);
    if (res['code'] == 200) {
      return res['encrypt_value'] == ''
          ? res['code']
          : AESUtil.decrypt2Base64(aesKey, res['encrypt_value']);
    } else {
      Toast.show(res['message'], context, duration: 1);
      return null;
    }
  }

  static showSnackBar(BuildContext ctx,
      {@required String text, IconData icon}) {
    Scaffold.of(ctx).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(icon),
          ),
          Text(text)
        ],
      ),
    ));
  }

  static Future showCommonDialog(
      {BuildContext context,
      String title = '提示',
      String content = '善意的提示',
      void ok()}) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 203, 27, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Text(
                '$title',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            titlePadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 80,
                child: Text(
                  '$content',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (ok == null) {
                    Navigator.of(context).pop();
                  } else {
                    ok();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
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
                    '确定',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          );
        });
  }

  // 图片地址拼接
  static dcImage(String url) {
    if (url.indexOf('http') != -1) {
      return url;
    } else {
      return assetsUrl + url;
    }
  }

  static setBasicInfo(userInfo) {
    // flutter模式 userInfo无baseUrl字段
    if (userInfo['baseUrl'] != null) {
      baseUrl = userInfo['baseUrl'];
    }
    token = userInfo['user_token'];
  }

  static getRandomDataInList(List list) {
    var random = math.Random();
    var index = random.nextInt(list.length);
    return list[index];
  }

  static Widget placeHolderAvtar(
      {@required String placeholder,
      @required String image,
      @required BuildContext context,
      double radius = 20.0,
      int userId,
      bool event = true}) {
    return GestureDetector(
        onTap: () {
          if (event) {
            if (userId != null) {
              Navigator.pushNamed(context, '/profile/otherUser',
                  arguments: {'otherUserId': userId.toString()});
            } else {
              Navigator.pushNamed(context, '/profile');
            }
          }
        },
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: ExactAssetImage(placeholder),
              radius: radius,
            ),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(image),
              radius: radius,
            ),
          ],
        ));
  }
}

// 与原生交互API
Future platformNavigator(BuildContext context,
    {String targetPage, arguments}) async {
  var result;
  if (targetPage != null) {
    if (window.defaultRouteName != "/") {
      try {
        result = await platform.invokeMethod(targetPage, arguments);
        return result;
      } catch (e) {
        throw e;
      }
    } else {
      print(targetPage);
    }
  } else {
    if (Platform.isAndroid) {
      if (Utils.isRootPage) {
        await SystemNavigator.pop();
        return false;
      } else {
        Navigator.of(context).pop();
      }
    } else if (Platform.isIOS) {
      try {
        if (Utils.isRootPage) {
          await platform.invokeMethod(PlatformCmd.NAVIGATOR_POP);
          return false;
        } else {
          Navigator.of(context).pop();
        }
      } on Exception catch (e) {
        throw e;
      }
    }
  }
}

Future platformShare(BuildContext context, String cmd) async {
  Navigator.of(context, rootNavigator: true).pop();
  if (window.defaultRouteName != '/') {
    var result = await platform.invokeMethod(cmd);
    return result;
  } else {
    print(cmd);
  }
}

Future platformStat(String eventId, {BuildContext context}) async {
  if (window.defaultRouteName != '/') {
    var result = platform.invokeMethod(PlatformCmd.EVENT_STATIS, eventId);
    return result;
  } else {
    print("eventId: $eventId");
  }
}

Future platformGetInfo(
  BuildContext context,
) async {
  var user;
  if (window.defaultRouteName != '/') {
    user = await platform.invokeMethod(PlatformCmd.GET_INFO);
    user = json.decode(user);
  } else {
    user = await Utils.requestHttp(
        url: '/user_login',
        data: {
          "mobilephone": "13777894840",
          "sms_code": "1234",
          "platform": 1,
          "account_type": 3,
          "version": "1.1",
          "release": 100
        },
        method: 'post',
        context: context);
  }
  Utils.setBasicInfo(user);
  return user;
}
