import 'package:yachtOne/models/user_vote_stats_model.dart';

class UserVoteModel {
  final String uid;
  final String voteDate;
  List<int> voteSelected;
  final List<int> voteResult;
  final bool voteVictory;
  bool isVoted;
  final UserVoteStatsModel userVoteStats;

  UserVoteModel({
    this.uid,
    this.voteDate,
    this.voteSelected,
    this.voteResult,
    this.voteVictory,
    this.isVoted,
    this.userVoteStats,
    // this.userVotes,
  });

// Json -> SubVoteModel
  UserVoteModel.fromData(
    Map<String, dynamic> data,
    UserVoteStatsModel userVoteStats,
  )   : uid = data['uid'],
        voteDate = data['voteDate'],
        // List<int>를 json으로 가져오면 List<dynamic>으로 인식하여 int로 다시 cast해줌
        voteSelected = data['voteSelected'] == null
            ? null
            : data['voteSelected'].cast<int>(),
        voteResult = data['voteResult'],
        voteVictory = data['voteVictory'],
        isVoted = data['isVoted'],
        userVoteStats = userVoteStats;

  // SubVoteModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'voteDate': this.voteDate,
      'voteSelected': this.voteSelected,
      'voteResult': this.voteResult,
      'voteVictory': this.voteVictory,
      'isVoted': this.isVoted,
    };
  }
}
