class RankModel {
  final String uid;
  final String userName;
  final int combo;

  RankModel({
    this.uid,
    this.userName,
    this.combo,
  });

  RankModel.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        userName = data['userName'],
        combo = data['combo'];

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'combo': this.combo,
    };
  }
}
