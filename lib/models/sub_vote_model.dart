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
  final String voteImgUrl;
  final List<String> voteChoices;
  final int numVoted;
  final int result;

  SubVote({
    this.id,
    this.title,
    this.voteImgUrl,
    this.voteChoices,
    this.numVoted,
    this.result,
  });
}
