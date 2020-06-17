class UserVoteModel {
  final String uid;
  final String voteDate;
  final int subVoteCount;
  List<int> voteSelected;
  final List<int> voteResult;
  final bool voteVictory;
  bool isVoted;

  UserVoteModel({
    this.uid,
    this.voteDate,
    this.subVoteCount,
    this.voteSelected,
    this.voteResult,
    this.voteVictory,
    this.isVoted,
    // this.userVotes,
  });

// Json -> SubVoteModel
  UserVoteModel.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        voteDate = data['voteDate'],
        subVoteCount = data['subVoteCount'],
        voteSelected = data['voteSelected'],
        voteResult = data['voteResult'],
        voteVictory = data['voteVictory'],
        isVoted = data['isVoted'];

  // SubVoteModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'voteDate': this.voteDate,
      'voteCount': this.subVoteCount,
      'voteSelected': this.voteSelected,
      'voteResult': this.voteResult,
      'voteVictory': this.voteVictory,
      'isVoted': this.isVoted,
    };
  }
}
