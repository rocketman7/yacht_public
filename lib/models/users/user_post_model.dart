import 'dart:convert';

class UserPostModel {
  final String postId;
  final dynamic writtenDateTime;
  final dynamic modifiedDateTime;
  final bool isPro;
  UserPostModel({
    required this.postId,
    required this.writtenDateTime,
    required this.modifiedDateTime,
    required this.isPro,
  });

  UserPostModel copyWith({
    String? postId,
    dynamic? writtenDateTime,
    dynamic? modifiedDateTime,
    bool? isPro,
  }) {
    return UserPostModel(
      postId: postId ?? this.postId,
      writtenDateTime: writtenDateTime ?? this.writtenDateTime,
      modifiedDateTime: modifiedDateTime ?? this.modifiedDateTime,
      isPro: isPro ?? this.isPro,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'writtenDateTime': writtenDateTime,
      'modifiedDateTime': modifiedDateTime,
      'isPro': isPro,
    };
  }

  factory UserPostModel.fromMap(Map<String, dynamic> map) {
    return UserPostModel(
      postId: map['postId'],
      writtenDateTime: map['writtenDateTime'],
      modifiedDateTime: map['modifiedDateTime'],
      isPro: map['isPro'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPostModel.fromJson(String source) => UserPostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserPostModel(postId: $postId, writtenDateTime: $writtenDateTime, modifiedDateTime: $modifiedDateTime, isPro: $isPro)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserPostModel &&
        other.postId == postId &&
        other.writtenDateTime == writtenDateTime &&
        other.modifiedDateTime == modifiedDateTime &&
        other.isPro == isPro;
  }

  @override
  int get hashCode {
    return postId.hashCode ^ writtenDateTime.hashCode ^ modifiedDateTime.hashCode ^ isPro.hashCode;
  }
}

// class UserCommentModel {}

// class OtherUserModel {
//   final String uid;
//   final String avatarUrl;
// }
