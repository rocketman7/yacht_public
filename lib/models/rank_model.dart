class RankModel {
  final String? uid;
  final String? userName;
  final int? currentWinPoint;
  final String? avatarImage;
  final int? prevRank;
  int? todayRank;

  RankModel({
    this.uid,
    this.userName,
    this.currentWinPoint,
    this.avatarImage,
    this.prevRank,
    this.todayRank,
  });

  RankModel.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        userName = data['userName'],
        currentWinPoint = data['currentWinPoint'],
        avatarImage = data['avatarImage'],
        prevRank = data['prevRank'],
        todayRank = data['todayRank'];

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'currentWinPoint': this.currentWinPoint,
      'avatarImage': this.avatarImage,
      'prevRank': this.prevRank,
      'todayRank': this.todayRank,
    };
  }
}
