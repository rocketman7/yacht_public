import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postUid;
  final String uid;
  final String replyTo;
  final List<dynamic> replyList;
  final String postText;
  final Timestamp postDateTime;
  final String parent;
  final List<dynamic> likedBy;

  PostModel({
    this.postUid,
    this.uid,
    this.replyTo,
    this.replyList,
    this.postText,
    this.postDateTime,
    this.parent,
    this.likedBy,
  });

  PostModel.fromData(String id, Map<String, dynamic> data)
      : postUid = id,
        uid = data['uid'],
        replyTo = data['replyTo'] ?? null,
        replyList = data['replyList'] ?? [],
        postText = data['postText'],
        postDateTime = data['postDateTime'],
        parent = data['parent'] ?? null,
        likedBy = data['likedBy'] ?? [];

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'replyTo': this.replyTo,
      'replyList': this.replyList,
      'postText': this.postText,
      'postDateTime': this.postDateTime,
      'parent': this.parent,
      'likedBy': this.likedBy,
    };
  }
}
