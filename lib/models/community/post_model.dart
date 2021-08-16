import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:get/get.dart';

class PostModel {
  final String? postId;
  final dynamic writtenDateTime; // 최초 쓴 시간
  final dynamic editedDateTime; // 최종 수정 시간
  final String? title;
  final String content;
  final List<String>? imageUrlList;
  final bool isPro; // 프로 글인지 체크
  final List<String>? commentedBy; // commentId List

  final List<String>? hashTags;
  final List<String>? likedBy;
  final List<String>? reportedBy;
  final List<String>? sharedBy;

  // Writer Info
  final String writerUid;
  final String writerUserName;
  final String? writerExp;
  final String? writerAvatarUrl;

  PostModel({
    this.postId,
    this.writtenDateTime,
    this.editedDateTime,
    this.title,
    required this.content,
    this.imageUrlList,
    required this.isPro,
    this.hashTags,
    this.commentedBy,
    this.likedBy,
    this.reportedBy,
    this.sharedBy,
    required this.writerUid,
    required this.writerUserName,
    this.writerExp,
    this.writerAvatarUrl,
  });

  PostModel copyWith({
    String? postId,
    dynamic? writtenDateTime,
    dynamic? editedDateTime,
    String? title,
    String? content,
    List<String>? imageUrlList,
    bool? isPro,
    List<String>? hashTags,
    List<String>? commentedBy,
    List<String>? likedBy,
    List<String>? reportedBy,
    List<String>? sharedBy,
    String? writerUid,
    String? writerUserName,
    String? writerExp,
    String? writerAvatarUrl,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      writtenDateTime: writtenDateTime ?? this.writtenDateTime,
      editedDateTime: editedDateTime ?? this.editedDateTime,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrlList: imageUrlList ?? this.imageUrlList,
      isPro: isPro ?? this.isPro,
      hashTags: hashTags ?? this.hashTags,
      commentedBy: commentedBy ?? this.commentedBy,
      likedBy: likedBy ?? this.likedBy,
      reportedBy: reportedBy ?? this.reportedBy,
      sharedBy: sharedBy ?? this.sharedBy,
      writerUid: writerUid ?? this.writerUid,
      writerUserName: writerUserName ?? this.writerUserName,
      writerExp: writerExp ?? this.writerExp,
      writerAvatarUrl: writerAvatarUrl ?? this.writerAvatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'writtenDateTime': writtenDateTime,
      'editedDateTime': editedDateTime,
      'title': title,
      'content': content,
      'imageUrlList': imageUrlList,
      'isPro': isPro,
      'hashTags': hashTags,
      'commentedBy': commentedBy,
      'likedBy': likedBy,
      'reportedBy': reportedBy,
      'sharedBy': sharedBy,
      'writerUid': writerUid,
      'writerUserName': writerUserName,
      'writerExp': writerExp,
      'writerAvatarUrl': writerAvatarUrl,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'],
      writtenDateTime: map['writtenDateTime'],
      editedDateTime: map['editedDateTime'],
      title: map['title'],
      content: map['content'],
      imageUrlList: map['imageUrlList'] == null
          ? null
          : List<String>.from(map['imageUrlList']),
      isPro: map['isPro'],
      hashTags:
          map['hashTags'] == null ? null : List<String>.from(map['hashTags']),
      commentedBy: map['commentedBy'] == null
          ? null
          : List<String>.from(map['commentedBy']),
      likedBy:
          map['likedBy'] == null ? null : List<String>.from(map['likedBy']),
      reportedBy: map['reportedBy'] == null
          ? null
          : List<String>.from(map['reportedBy']),
      sharedBy:
          map['sharedBy'] == null ? null : List<String>.from(map['sharedBy']),
      writerUid: map['writerUid'],
      writerUserName: map['writerUserName'],
      writerExp: map['writerExp'],
      writerAvatarUrl: map['writerAvatarUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PostModel(postId: $postId, writtenDateTime: $writtenDateTime, editedDateTime: $editedDateTime, title: $title, content: $content, imageUrlList: $imageUrlList, isPro: $isPro, hashTags: $hashTags, commentedBy: $commentedBy, likedBy: $likedBy, reportedBy: $reportedBy, sharedBy: $sharedBy, writerUid: $writerUid, writerUserName: $writerUserName, writerExp: $writerExp, writerAvatarUrl: $writerAvatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is PostModel &&
        other.postId == postId &&
        other.writtenDateTime == writtenDateTime &&
        other.editedDateTime == editedDateTime &&
        other.title == title &&
        other.content == content &&
        listEquals(other.imageUrlList, imageUrlList) &&
        other.isPro == isPro &&
        listEquals(other.hashTags, hashTags) &&
        listEquals(other.commentedBy, commentedBy) &&
        listEquals(other.likedBy, likedBy) &&
        listEquals(other.reportedBy, reportedBy) &&
        listEquals(other.sharedBy, sharedBy) &&
        other.writerUid == writerUid &&
        other.writerUserName == writerUserName &&
        other.writerExp == writerExp &&
        other.writerAvatarUrl == writerAvatarUrl;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        writtenDateTime.hashCode ^
        editedDateTime.hashCode ^
        title.hashCode ^
        content.hashCode ^
        imageUrlList.hashCode ^
        isPro.hashCode ^
        hashTags.hashCode ^
        commentedBy.hashCode ^
        likedBy.hashCode ^
        reportedBy.hashCode ^
        sharedBy.hashCode ^
        writerUid.hashCode ^
        writerUserName.hashCode ^
        writerExp.hashCode ^
        writerAvatarUrl.hashCode;
  }
}

// class CommentModel {
//   final String commentId;
//   final String writerUid;
//   final dynamic writtenDateTime; // 최초 쓴 시간
//   final dynamic modifiedDateTime; // 최종 수정 시간
//   final String postId; // 코멘트 단 포스트 id
//   final String title;
//   final String content;

//   final List<String> likedBy;
//   final List<String> reportedBy;
// }
