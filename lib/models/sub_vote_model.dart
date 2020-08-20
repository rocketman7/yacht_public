class SubVote {
// var VOTE_DATA = [
//   {
//     'title': '9월 2일 코스피 방향은?',
//     'voteImg':
//         'https://img5.yna.co.kr/photo/yna/YH/2020/01/29/PYH2020012920480032500_P4.jpg',
//     'voteStartDate': startDate,
//     'voteEndDate': endDate,
//     'voteChoices': ['상승', '하락'],
//     'choiceCounts': 2,
//     'Result': null
//   },
  final int id;
  final String title;
  final String description;
  final String voteImgUrl;
  final List<dynamic> voteChoices;
  final int numVoted0;
  final int numVoted1;
  final int result;

  SubVote({
    this.id,
    this.title,
    this.description,
    this.voteImgUrl,
    this.voteChoices,
    this.numVoted0,
    this.numVoted1,
    this.result,
  });

// Json -> SubVoteModel
  SubVote.fromData(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        description = data['description'],
        voteImgUrl = data['voteImgUrl'],
        voteChoices = data['voteChoices'],
        numVoted0 = data['numVoted0'],
        numVoted1 = data['numVoted1'],
        result = data['result'];

  // SubVoteModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'voteImgUrl': this.voteImgUrl,
      'voteChoices': this.voteChoices,
      'numVoted0': this.numVoted0,
      'numVoted1': this.numVoted1,
      'result': this.result,
    };
  }
}
