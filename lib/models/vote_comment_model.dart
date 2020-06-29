class VoteCommentModel {
  final String uid;
  final String userName;
  final String postText;
  final int like;
  final int dislike;
  final DateTime postDateTime;

  VoteCommentModel({
    this.uid,
    this.userName,
    this.postText,
    this.like,
    this.dislike,
    this.postDateTime,
  });

  VoteCommentModel.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        userName = data['userName'],
        postText = data['postText'],
        like = data['like'],
        dislike = data['dislke'],
        postDateTime = data['postDateTime'];

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'postText': this.postText,
      'like': this.like,
      'dislike': this.dislike,
      'postDateTime': this.postDateTime,
    };
  }
}
