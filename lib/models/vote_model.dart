import 'package:yachtOne/models/sub_vote_model.dart';

class VoteModel {
  final DateTime voteDate;
  final DateTime voteStartDateTime;
  final DateTime voteEndDateTime;
  final int voteCount;
  final List<int> voteResult;
  final List<SubVote> subVotes;

  VoteModel({
    this.voteDate,
    this.voteStartDateTime,
    this.voteEndDateTime,
    this.voteCount,
    this.voteResult,
    this.subVotes,
  });
}

VoteModel voteToday = VoteModel(
  voteDate: DateTime(2020, 09, 01),
  voteStartDateTime: DateTime.utc(2020, 9, 1, 7, 0, 0), // KST 2020/09/01 16:00
  voteEndDateTime: DateTime.utc(2020, 9, 1, 23, 50, 0), // KST 2020/09/02 08:50
  voteCount: 5,
  subVotes: subVotes,
);

List<SubVote> subVotes = [
  SubVote(
    title: '9월 2일 코스피 방향은?',
    voteImgUrl:
        'https://i.etsystatic.com/13295640/r/il/ac02ed/2229579037/il_794xN.2229579037_rrqo.jpg',
    voteChoices: ['상승', '하락'],
  ),
  SubVote(
    title: '9월 2일 달러 환율의 방향은?',
    voteImgUrl:
        'https://image.freepik.com/free-vector/worl-currency-icons_23-2147535054.jpg',
    voteChoices: ['상승', '하락'],
  ),
  SubVote(
    title: '9월 2일 수익률 승자는?',
    voteImgUrl:
        'https://cdn.dribbble.com/users/2394908/screenshots/10514933/tech-illustration-3_4x.jpg',
    voteChoices: ['네이버', '카카오'],
  ),
  SubVote(
    title: '9월 2일 수익률 승자는?',
    voteImgUrl:
        'https://cdn.dribbble.com/users/220973/screenshots/3719316/healthcare.png',
    voteChoices: ['대웅제약', '일양약품'],
  ),
  SubVote(
    title: '9월 2일 수익률 승자는?',
    voteImgUrl:
        'https://thumbs.dreamstime.com/z/semiconductor-isometric-background-130533461.jpg',
    voteChoices: ['삼성전자', '하이닉스'],
  ),
];
