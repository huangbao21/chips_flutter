import 'package:chips_flutter/redux_actions.dart';

getUserInfoReducer(state,action){
  if(action is GetUserInfoAction){
    return action.userInfo;
  }else{
    return state;
  }
}
getPersonalInfoReducer(state,action){
    if(action is GetPersonalInfoAction){
      if(action.offlineUpdate){
        state[action.extraKey] = action.personalInfo;
      }else{
        return action.personalInfo;
      }
    return state;
  }else{
    return state;
  }
}
rankListReducer(state, action,rankTime) {
  if (action is RankListAction && action.rankTime == rankTime) {
    return action.rankData;
  }
  return state;
}