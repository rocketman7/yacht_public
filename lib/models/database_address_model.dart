import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/services/database_service.dart';

// final CollectionReference _usersCollectionReference =
//     FirebaseFirestore.instance.collection('users');
DatabaseService _databaseService = locator<DatabaseService>();

class DatabaseAddressModel {
  final String uid;
  final String date;
  final String category;
  final String season;
  String subVote;

  DatabaseAddressModel({
    this.uid,
    this.date,
    this.category,
    this.season,
    this.subVote,
  });

  // users collection의 userVote subCollection Ref.
  CollectionReference userVoteCollection() {
    return _databaseService.usersCollectionReference
        .doc(uid)
        .collection('userVote');
  }

// users collection의 userVote subCollection의 season subCollection Ref.
  CollectionReference userVoteSeasonCollection() {
    return _databaseService.usersCollectionReference
        .doc(uid)
        .collection('userVote')
        .doc(category)
        .collection(season);
  }

  // users collection의 userVote subCollection의 season subCollection의 stats doc Ref.
  DocumentReference userVoteSeasonStatsCollection() {
    return _databaseService.usersCollectionReference
        .doc(uid)
        .collection('userVote')
        .doc(category)
        .collection(season)
        .doc('stats');
  }

  // users collection의 userPost subCollection Ref.
  CollectionReference userPostCollection() {
    return _databaseService.usersCollectionReference
        .doc(uid)
        .collection('userPost');
  }

  // users collection의 userReward subColelction Ref.
  CollectionReference userRewardCollection() {
    return _databaseService.usersCollectionReference
        .doc(uid)
        .collection('userReward');
  }

  // votes collection의 season subCollection Ref.
  CollectionReference votesSeasonCollection() {
    return _databaseService.votesCollectionReference
        .doc(category)
        .collection(season);
  }

// votes collection의 season subCollection의 subVote subCollection Ref.
// 여기에는 특정 카테고리,특정 시즌, 특정 날짜의 subVote들을 담아놓은 docu가 있음
  CollectionReference votesSeasonSubVoteCollection() {
    return _databaseService.votesCollectionReference
        .doc(category)
        .collection(season)
        .doc(date)
        .collection('subVote');
  }

// votes collection의 season subCollection의 awardPortfolio subCollection Ref.

  CollectionReference votesSeasonAwardPortfolioCollection() {
    return _databaseService.votesCollectionReference
        .doc(category)
        .collection(season)
        .doc('seasonInfo')
        .collection('awardPortfolio');
  }

  // posts collection의 season subCollection의 개별 subVote 게시판 Ref.
  CollectionReference postsSeasonSubVoteCollection() {
    return _databaseService.postsCollectionReference
        .doc(category)
        .collection(season)
        .doc(date)
        .collection(subVote);
  }

  // posts collection의 season subCollection의 시즌 전체 게시판 Ref.
  CollectionReference postsSeasonSeasonPostCollection() {
    return _databaseService.postsCollectionReference
        .doc(category)
        .collection(season)
        .doc('seasonPost')
        .collection('seasonPost');
  }

  // ranks collection의 season subCollection의 날짜 data Ref.
  CollectionReference ranksSeasonDateCollection() {
    return _databaseService.ranksCollectionReference
        .doc(season)
        .collection(date);
  }
}
