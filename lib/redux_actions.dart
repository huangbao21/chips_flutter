class GetUserInfoAction {
  final userInfo;
  
  GetUserInfoAction(this.userInfo);
}
class GetPersonalInfoAction{
  final personalInfo;
  final otherUserId;
  /// need to update value by key
  final String extraKey;
  final bool offlineUpdate;
  GetPersonalInfoAction(this.personalInfo,this.otherUserId,{this.offlineUpdate = false,this.extraKey='user_info'});
}
class RankListAction {
  final rankType;
  final rankTime;
  final rankData;
  RankListAction(rankType, {rankTime, rankData})
      : rankType = rankType,
        rankTime = rankTime ?? 'all',
        rankData = rankData ?? [];
}