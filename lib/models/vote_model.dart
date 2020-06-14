import 'package:yachtOne/models/sub_vote_model.dart';

class VoteModel {
  final String voteDate;
  final dynamic voteStartDateTime;
  final dynamic voteEndDateTime;
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

  // Json -> VoteModel 변환 constructor
  VoteModel.fromData(Map<String, dynamic> data, List<SubVote> subVotesList)
      : voteDate = data['voteDate'],
        voteStartDateTime = data['voteStartDateTime'],
        voteEndDateTime = data['voteEndDateTime'],
        voteCount = data['voteCount'],
        voteResult = data['voteResult'],
        subVotes = subVotesList;

  // VoteModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'voteDate': this.voteDate,
      'voteStartDateTime': this.voteStartDateTime,
      'voteEndDateTime': this.voteEndDateTime,
      'voteCount': this.voteCount,
      'voteResult': this.voteResult,
    };
  }
}

VoteModel voteToday = VoteModel(
  voteDate: '20200901',
  voteStartDateTime: DateTime.utc(2020, 9, 1, 7, 0, 0), // KST 2020/09/01 16:00
  voteEndDateTime: DateTime.utc(2020, 6, 14, 23, 50, 0), // KST 2020/09/02 08:50
  voteCount: 5,
  subVotes: subVotes,
);

List<SubVote> subVotes = [
  SubVote(
    id: 0,
    title: '9월 2일 코스피 방향은?',
    voteImgUrl:
        'https://www.lifewire.com/thmb/7p4to3rZIu693iX4Cmd3iroVQE0=/768x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/GettyImages-1066987348-66e3879d27d244b3b8276484db518bb5.jpg',
    voteChoices: ['KOSPI 상승', '하락'],
    numVoted: 13400,
  ),
  SubVote(
    id: 1,
    title: '9월 2일 달러 환율의 방향은?',
    voteImgUrl:
        'https://image.freepik.com/free-vector/worl-currency-icons_23-2147535054.jpg',
    voteChoices: ['환율 상승', '하락'],
    numVoted: 15402,
  ),
  SubVote(
    id: 2,
    title: '9월 2일 수익률 승자는?',
    voteImgUrl:
        'https://cdn.dribbble.com/users/2394908/screenshots/10514933/tech-illustration-3_4x.jpg',
    voteChoices: ['네이버', '카카오'],
    numVoted: 7823,
  ),
  SubVote(
    id: 3,
    title: '9월 2일 수익률 승자는?',
    voteImgUrl:
        'https://cdn.dribbble.com/users/220973/screenshots/3719316/healthcare.png',
    voteChoices: ['대웅제약', '일양약품'],
    numVoted: 23142,
  ),
  SubVote(
    id: 4,
    title: '9월 2일 수익률 승자는?',
    voteImgUrl:
        'https://thumbs.dreamstime.com/z/semiconductor-isometric-background-130533461.jpg',
    voteChoices: ['삼성전자', '하이닉스'],
    numVoted: 11924,
  ),
];
