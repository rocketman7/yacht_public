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
  final String selectDescription;
  final String ggookDescription;
  final String voteImgUrl;
  final List<dynamic> voteChoices;
  final List<dynamic> tag0;
  final List<dynamic> tag1;
  final int numVoted0;
  final int numVoted1;
  final int result;
  final List<dynamic> issueCode;
  final List<dynamic> colorCode;

  SubVote({
    this.id,
    this.title,
    this.selectDescription,
    this.ggookDescription,
    this.voteImgUrl,
    this.voteChoices,
    this.tag0,
    this.tag1,
    this.numVoted0,
    this.numVoted1,
    this.result,
    this.issueCode,
    this.colorCode,
  });

// Json -> SubVoteModel
  SubVote.fromData(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        selectDescription = data['selectDescription'],
        ggookDescription = data['ggookDescription'],
        voteImgUrl = data['voteImgUrl'],
        voteChoices = data['voteChoices'],
        tag0 = data['tag0'],
        tag1 = data['tag1'],
        numVoted0 = data['numVoted0'],
        numVoted1 = data['numVoted1'],
        issueCode = data['issueCode'],
        result = data['result'],
        colorCode = data['colorCode'] ?? null;

  // SubVoteModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'selectDescription': this.selectDescription,
      'ggookDescription': this.ggookDescription,
      'tag0': this.tag0,
      'tag1': this.tag1,
      'voteImgUrl': this.voteImgUrl,
      'voteChoices': this.voteChoices,
      'numVoted0': this.numVoted0,
      'numVoted1': this.numVoted1,
      'result': this.result,
    };
  }
}
