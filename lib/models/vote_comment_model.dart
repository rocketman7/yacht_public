import 'package:cloud_firestore/cloud_firestore.dart';

class VoteCommentModel {
  final String postUid;
  final String uid;
  final String userName;
  final String postText;
  final List<dynamic> likedBy;
  final Timestamp postDateTime;
  final String choice;

  VoteCommentModel({
    this.postUid,
    this.uid,
    this.userName,
    this.postText,
    this.likedBy,
    this.postDateTime,
    this.choice,
  });

  VoteCommentModel.fromData(String id, Map<String, dynamic> data)
      : postUid = id,
        uid = data['uid'],
        userName = data['userName'],
        postText = data['postText'],
        likedBy = data['likedBy'] ?? [],
        postDateTime = data['postDateTime'],
        choice = data['choice'];

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'postText': this.postText,
      'likedBy': this.likedBy,
      'postDateTime': this.postDateTime,
      'choice': this.choice,
    };
  }
}
