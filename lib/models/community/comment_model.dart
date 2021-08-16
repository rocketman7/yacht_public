import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:get/get.dart';

class CommentModel {
  // 댓글=comment=코멘트, 대댓글=reply
  final String? commentId; // 댓글의 ID
  final String commentToPostId; // 댓글이 향하는 Post ID

  final dynamic writtenDateTime; // 댓글 쓴 시각
  final dynamic editedDateTime; // 댓글 수정한 시각
  final String content; // 댓글 내용
  final List<String>? repliedBy; // 달린 대댓글의 commentId List

  //여기서 reply는 대댓글을 의미합니다.
  final bool isReply; // 대댓글 여부
  // 코멘트 뷰에 들어왔을 때
  // 1) isReply가 false인 comment들을 writtenDateTime 최신순으로 정렬한다
  // 2) repliedBy length가 >0 이면, 코멘트 바로 아래에 대댓글 위젯으로
  //    repliedBy의 대댓글 commentId의 commentModel을 그린다.

  final String? replyToCommentId; // 대댓글이 향하는 댓글 ID
  final String? replyToUserUid; // 대댓글이 향하는 댓글 쓴 사람 UID
  final String? replyToUserName; // 대댓글이 향하는 댓글 쓴 사람 유저네임
  final List<String>? likedBy;
  final List<String>? reportedBy;

  // Writer Info
  final String writerUid;
  final String writerUserName;
  final String? writerExp;
  final String? writerAvatarUrl;
  CommentModel({
    this.commentId,
    required this.commentToPostId,
    this.writtenDateTime,
    this.editedDateTime,
    required this.content,
    this.repliedBy,
    required this.isReply,
    this.replyToCommentId,
    this.replyToUserUid,
    this.replyToUserName,
    this.likedBy,
    this.reportedBy,
    required this.writerUid,
    required this.writerUserName,
    this.writerExp,
    this.writerAvatarUrl,
  });

  CommentModel copyWith({
    String? commentId,
    String? commentToPostId,
    dynamic? writtenDateTime,
    dynamic? editedDateTime,
    String? content,
    List<String>? repliedBy,
    bool? isReply,
    String? replyToCommentId,
    String? replyToUserUid,
    String? replyToUserName,
    List<String>? likedBy,
    List<String>? reportedBy,
    String? writerUid,
    String? writerUserName,
    String? writerExp,
    String? writerAvatarUrl,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      commentToPostId: commentToPostId ?? this.commentToPostId,
      writtenDateTime: writtenDateTime ?? this.writtenDateTime,
      editedDateTime: editedDateTime ?? this.editedDateTime,
      content: content ?? this.content,
      repliedBy: repliedBy ?? this.repliedBy,
      isReply: isReply ?? this.isReply,
      replyToCommentId: replyToCommentId ?? this.replyToCommentId,
      replyToUserUid: replyToUserUid ?? this.replyToUserUid,
      replyToUserName: replyToUserName ?? this.replyToUserName,
      likedBy: likedBy ?? this.likedBy,
      reportedBy: reportedBy ?? this.reportedBy,
      writerUid: writerUid ?? this.writerUid,
      writerUserName: writerUserName ?? this.writerUserName,
      writerExp: writerExp ?? this.writerExp,
      writerAvatarUrl: writerAvatarUrl ?? this.writerAvatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'commentToPostId': commentToPostId,
      'writtenDateTime': writtenDateTime,
      'editedDateTime': editedDateTime,
      'content': content,
      'repliedBy': repliedBy,
      'isReply': isReply,
      'replyToCommentId': replyToCommentId,
      'replyToUserUid': replyToUserUid,
      'replyToUserName': replyToUserName,
      'likedBy': likedBy,
      'reportedBy': reportedBy,
      'writerUid': writerUid,
      'writerUserName': writerUserName,
      'writerExp': writerExp,
      'writerAvatarUrl': writerAvatarUrl,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'],
      commentToPostId: map['commentToPostId'],
      writtenDateTime: map['writtenDateTime'],
      editedDateTime: map['editedDateTime'],
      content: map['content'],
      repliedBy:
          map['repliedBy'] == null ? null : List<String>.from(map['repliedBy']),
      isReply: map['isReply'],
      replyToCommentId: map['replyToCommentId'],
      replyToUserUid: map['replyToUserUid'],
      replyToUserName: map['replyToUserName'],
      likedBy:
          map['likedBy'] == null ? null : List<String>.from(map['likedBy']),
      reportedBy: map['reportedBy'] == null
          ? null
          : List<String>.from(map['reportedBy']),
      writerUid: map['writerUid'],
      writerUserName: map['writerUserName'],
      writerExp: map['writerExp'],
      writerAvatarUrl: map['writerAvatarUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommentModel(commentId: $commentId, commentToPostId: $commentToPostId, writtenDateTime: $writtenDateTime, editedDateTime: $editedDateTime, content: $content, repliedBy: $repliedBy, isReply: $isReply, replyToCommentId: $replyToCommentId, replyToUserUid: $replyToUserUid, replyToUserName: $replyToUserName, likedBy: $likedBy, reportedBy: $reportedBy, writerUid: $writerUid, writerUserName: $writerUserName, writerExp: $writerExp, writerAvatarUrl: $writerAvatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is CommentModel &&
        other.commentId == commentId &&
        other.commentToPostId == commentToPostId &&
        other.writtenDateTime == writtenDateTime &&
        other.editedDateTime == editedDateTime &&
        other.content == content &&
        listEquals(other.repliedBy, repliedBy) &&
        other.isReply == isReply &&
        other.replyToCommentId == replyToCommentId &&
        other.replyToUserUid == replyToUserUid &&
        other.replyToUserName == replyToUserName &&
        listEquals(other.likedBy, likedBy) &&
        listEquals(other.reportedBy, reportedBy) &&
        other.writerUid == writerUid &&
        other.writerUserName == writerUserName &&
        other.writerExp == writerExp &&
        other.writerAvatarUrl == writerAvatarUrl;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        commentToPostId.hashCode ^
        writtenDateTime.hashCode ^
        editedDateTime.hashCode ^
        content.hashCode ^
        repliedBy.hashCode ^
        isReply.hashCode ^
        replyToCommentId.hashCode ^
        replyToUserUid.hashCode ^
        replyToUserName.hashCode ^
        likedBy.hashCode ^
        reportedBy.hashCode ^
        writerUid.hashCode ^
        writerUserName.hashCode ^
        writerExp.hashCode ^
        writerAvatarUrl.hashCode;
  }
}
