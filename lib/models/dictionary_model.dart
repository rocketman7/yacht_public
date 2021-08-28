import 'dart:convert';

class DictionaryModel {
  final String title;
  final String imageUrl;
  final String dictionaryUrl;
  final dynamic updateDateTime;
  final bool? showHomeView;
  DictionaryModel({
    required this.title,
    required this.imageUrl,
    required this.dictionaryUrl,
    required this.updateDateTime,
    this.showHomeView,
  });

  DictionaryModel copyWith({
    String? title,
    String? imageUrl,
    String? dictionaryUrl,
    dynamic? updateDateTime,
    bool? showHomeView,
  }) {
    return DictionaryModel(
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      dictionaryUrl: dictionaryUrl ?? this.dictionaryUrl,
      updateDateTime: updateDateTime ?? this.updateDateTime,
      showHomeView: showHomeView ?? this.showHomeView,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'dictionaryUrl': dictionaryUrl,
      'updateDateTime': updateDateTime,
      'showHomeView': showHomeView,
    };
  }

  factory DictionaryModel.fromMap(Map<String, dynamic> map) {
    return DictionaryModel(
      title: map['title'],
      imageUrl: map['imageUrl'],
      dictionaryUrl: map['dictionaryUrl'],
      updateDateTime: map['updateDateTime'],
      showHomeView: map['showHomeView'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DictionaryModel.fromJson(String source) => DictionaryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DictionaryModel(title: $title, imageUrl: $imageUrl, dictionaryUrl: $dictionaryUrl, updateDateTime: $updateDateTime, showHomeView: $showHomeView)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DictionaryModel &&
        other.title == title &&
        other.imageUrl == imageUrl &&
        other.dictionaryUrl == dictionaryUrl &&
        other.updateDateTime == updateDateTime &&
        other.showHomeView == showHomeView;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        imageUrl.hashCode ^
        dictionaryUrl.hashCode ^
        updateDateTime.hashCode ^
        showHomeView.hashCode;
  }
}
