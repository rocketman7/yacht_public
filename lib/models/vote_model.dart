import '../models/sub_vote_model.dart';

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
  VoteModel.fromData(
    Map<String, dynamic> data,
    List<SubVote> subVotesList,
  )   : voteDate = data['voteDate'],
        voteStartDateTime = data['voteStartDateTime'],
        voteEndDateTime = data['voteEndDateTime'],
        voteCount = data['voteCount'],
        voteResult =
            data['voteResult'] == null ? [] : data['voteResult'].cast<int>(),
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

// VoteModel voteToday = VoteModel(
//   voteDate: '20200909',
//   voteStartDateTime: DateTime.utc(2020, 9, 8, 8, 50, 0), // KST 2020/09/01 16:00
//   voteEndDateTime: DateTime.utc(2020, 9, 8, 16, 00, 0), // KST 2020/09/02 08:50
//   voteCount: 3,
//   subVotes: subVotes,
// );

// List<SubVote> subVotes = [
//   SubVote(
//     id: 0,
//     title: 'KOSPI',
//     voteImgUrl:
//         'https://www.lifewire.com/thmb/7p4to3rZIu693iX4Cmd3iroVQE0=/768x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/GettyImages-1066987348-66e3879d27d244b3b8276484db518bb5.jpg',
//     voteChoices: ['상승', '하락'],
//   ),
//   SubVote(
//     id: 1,
//     title: 'LG화학',
//     voteImgUrl:
//         'https://image.freepik.com/free-vector/worl-currency-icons_23-2147535054.jpg',
//     voteChoices: ['상승', '하락'],
//   ),
//   SubVote(
//     id: 2,
//     title: '셀트리온헬스케어',
//     voteImgUrl:
//         'https://cdn.dribbble.com/users/2394908/screenshots/10514933/tech-illustration-3_4x.jpg',
//     voteChoices: ['상승', '하락'],
//   ),
// ];
