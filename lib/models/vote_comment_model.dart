import 'package:cloud_firestore/cloud_firestore.dart';

class VoteCommentModel {
  final String postUid;
  final String uid;
  final String userName;
  final String postText;
  final int like;
  final int dislike;
  final Timestamp postDateTime;
  final String choice;

  VoteCommentModel({
    this.postUid,
    this.uid,
    this.userName,
    this.postText,
    this.like,
    this.dislike,
    this.postDateTime,
    this.choice,
  });

  VoteCommentModel.fromData(String id, Map<String, dynamic> data)
      : postUid = id,
        uid = data['uid'],
        userName = data['userName'],
        postText = data['postText'],
        like = data['like'],
        dislike = data['dislke'],
        postDateTime = data['postDateTime'],
        choice = data['choice'];

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'postText': this.postText,
      'like': this.like,
      'dislike': this.dislike,
      'postDateTime': this.postDateTime,
      'choice': this.choice,
    };
  }
}
