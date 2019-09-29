import 'package:chips_flutter/redux_actions.dart';
import 'package:chips_flutter/redux_reducer.dart';
import 'package:chips_flutter/utils.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

@immutable
class AppState {
  final allRankList;
  final todayRankList;
  final yesterdayRankList;
  final lastRankList;
  final userInfo;
  final personalInfo;
  AppState(
      {@required this.allRankList,
      @required this.todayRankList,
      @required this.yesterdayRankList,
      @required this.lastRankList,
      @required this.userInfo,
      @required this.personalInfo});
  AppState.initState()
      : allRankList = null,
        todayRankList = null,
        yesterdayRankList = null,
        lastRankList = null,
        userInfo = null,
        personalInfo = null;
}

enum Actions {
  Increment,
}

AppState appReducer(AppState state, action) {
  return AppState(
    userInfo: getUserInfoReducer(state.userInfo, action),
    personalInfo: getPersonalInfoReducer(state.personalInfo, action),
    allRankList: rankListReducer(state.allRankList, action, 'all'),
    todayRankList: rankListReducer(state.todayRankList, action, 'today'),
    yesterdayRankList:
        rankListReducer(state.yesterdayRankList, action, 'yesterday'),
    lastRankList: rankListReducer(state.lastRankList, action, 'lastweek'),
  );
}

void middleware(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action == GetUserInfoAction) {
    platformGetInfo(Utils.platformContxt).then((json) {
      next(GetUserInfoAction(json));
    });
  } else if (action is GetPersonalInfoAction) {
    if (!action.offlineUpdate) {
      Utils.requestHttp(
          url: '/user_info_card',
          context: Utils.platformContxt,
          data: {'user_id': action.otherUserId},
          method: 'get',
          callback: (json) {
            next(GetPersonalInfoAction(json, action.otherUserId));
          });
    } else {
      next(GetPersonalInfoAction(action.personalInfo, action.otherUserId,
          offlineUpdate: true, extraKey: action.extraKey));
    }
  } else {
    next(action);
  }
}

void rankMiddleware(
    Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is RankListAction) {
    Utils.requestHttp(
        url: '/leaderboard',
        data: {'type': action.rankType, 'time': action.rankTime},
        method: 'get',
        context: Utils.platformContxt,
        callback: (json) {
          json['total_list'] = json['total_list'];
          next(RankListAction(action.rankType,
              rankData: json, rankTime: action.rankTime));
        });
  } else {
    next(action);
  }
}
