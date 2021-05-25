import 'package:stacked/stacked.dart';

import '../locator.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/post_model.dart';

// 커뮤니티 메인페이지에서 포스트콜렉션의 하위다큐, 콜렉션인 "KR", "000080" 등 종목코드를 넘겨준다고 가정
class CommunityViewModel extends FutureViewModel {
  final AuthService? _authService = locator<AuthService>();
  final DatabaseService? _databaseService = locator<DatabaseService>();

  final String category;
  final String issueCode;
  final String name;

  String? uid;

  //KR 등 카테고리와 000080 등 종목의 이슈코드
  //자유게시판은 KR 이 아닌 카테고리. 밑에 이슈코드는 더미로 넣어놓거나 하면 될듯
  CommunityViewModel(this.category, this.issueCode, this.name) {
    uid = _authService!.auth.currentUser!.uid;
  }

  Future initCommunityViewModel() async {
    print('initCommunityViewModel');
  }

  @override
  Future futureToRun() => initCommunityViewModel();

  //for futurebuilder
  // 그냥 이름까지 같이 넘겨주는 식으로 구현. 이러면 다른 Read가 필수적으로 하나 추가되기 때문에
  // Future<String> getStockName() async {
  //   await Future.delayed(Duration(seconds: 1));

  //   return '하이트진로';
  // }
  Future getAvatar(String? uid) async {
    return await _databaseService!.getAvatar(uid);
  }

  Future getNickName(String? uid) async {
    return await _databaseService!.getNickName(uid);
  }

  //for Stream
  Stream<List<PostModel>> getPost() {
    return _databaseService!.getPostList(category, issueCode);
  }
}
// import 'package:stacked/stacked.dart';
// import 'package:yachtOne/models/price_model.dart';
// import 'package:yachtOne/models/user_post_model.dart';
// import 'package:yachtOne/services/amplitude_service.dart';
// import '../models/vote_comment_model.dart';
// import '../models/database_address_model.dart';
// import '../models/user_model.dart';
// import '../models/user_vote_model.dart';
// import '../models/vote_model.dart';
// import '../services/navigation_service.dart';
// import '../services/auth_service.dart';
// import '../services/dialog_service.dart';
// import '../services/database_service.dart';
// import '../services/api/customized_ntp.dart';

// import '../locator.dart';

// class SubjectCommunityViewModel extends FutureViewModel {
//   final NavigationService _navigationService = locator<NavigationService>();
//   final AuthService _authService = locator<AuthService>();
//   final DialogService _dialogService = locator<DialogService>();
//   final DatabaseService _databaseService = locator<DatabaseService>();
//   final AmplitudeService _amplitudeService = AmplitudeService();
//   String uid;
//   final int idx;
//   final String date;

//   DatabaseAddressModel address;
//   UserModel user;
//   VoteModel vote;
//   UserVoteModel userVote;
//   DatabaseAddressModel newAddress;
//   String avatarImage;
//   DateTime now;
//   SubjectCommunityViewModel(this.date, this.idx) {
//     uid = _authService.auth.currentUser.uid;
//   }

//   @override
//   Future futureToRun() => getAllModel(uid);

//   Future getAllModel(uid) async {
//     // setBusy(true);
//     await _amplitudeService.logSubjectCommunity(uid);
//     address = await _databaseService.getAddress(uid);
//     newAddress = DatabaseAddressModel(
//       uid: uid,
//       date: date,
//       category: address.category,
//       season: address.season,
//       isVoting: address.isVoting,
//     );
//     newAddress.subVote = idx.toString();
//     // print(address);
//     user = await _databaseService.getUser(uid);
//     vote = await _databaseService.getVotes(newAddress);
//     userVote = await _databaseService.getUserVote(newAddress);

//     // setBusy(false);
//     // notifyListeners();
//   }

//   // Future getNowFromNetwork() async {
//   //   now = await CustomizedNTP.now();
//   //   // notifyListeners();
//   // }

//   Future postComments(
//     DatabaseAddressModel address,
//     VoteCommentModel voteCommentModel,
//   ) async {
//     print("Async Start");

//     UserPostModel userPostModel;
//     userPostModel = UserPostModel(
//       category: address.category,
//       season: address.season,
//       subVote: address.subVote,
//       date: address.date,
//       createdAt: voteCommentModel.postDateTime,
//     );
//     await _databaseService.postSubVoteComment(
//       address,
//       voteCommentModel,
//       userPostModel,
//     );
//   }

//   // Future deleteComment(
//   //   DatabaseAddressModel address,
//   //   String postUid,
//   // ) async {
//   //   print("Dialog shown");
//   //   var dialogResult = await _dialogService.showDialog(
//   //       title: "코멘트 삭제",
//   //       description: "해당 코멘트를 정말 삭제하시겠습니까?",
//   //       buttonTitle: "Yes",
//   //       cancelTitle: "No");

//   //   if (dialogResult.confirmed) {
//   //     print("user Confirmed");
//   //     await _databaseService.deleteSeasonComment(address, postUid);
//   //   } else {
//   //     print("user Not Confirmed");
//   //   }
//   // }

//   Future deleteComment(
//     DatabaseAddressModel address,
//     String postUid,
//   ) async {
//     await _databaseService.deleteSubjectComment(address, postUid);
//   }

//   Future likeComment(
//     VoteCommentModel voteComment,
//   ) async {
//     await _databaseService.likeSubVoteComment(
//       newAddress,
//       voteComment,
//       uid,
//     );
//   }

//   Future addBlockList(
//     UserModel user,
//     VoteCommentModel voteComment,
//   ) async {
//     await _databaseService.addBlockList(user, voteComment.uid);
//   }

//   Future getAvatar(String uid) async {
//     return await _databaseService.getAvatar(uid);
//   }

//   Stream<List<VoteCommentModel>> getPost(DatabaseAddressModel address) {
//     return _databaseService.getSubVotePostList(address);
//   }

//   Stream<PriceModel> getRealtimePrice(
//     DatabaseAddressModel address,
//     String issueCode,
//   ) {
//     print("Price Stream returns");
//     return _databaseService.getRealtimeReturn(address, issueCode);
//   }

// //   List<String> listIssueCode(int idx) {
// //     List<String> issueCodes = [];
// //     print("CALLED");
// //     for (int i = 0; i < vote.subVotes[idx].issueCode.length; i++) {
// //       issueCodes.add(vote.subVotes[idx].issueCode[i]);
// //     }
// //     return issueCodes;
// //   }
// }
