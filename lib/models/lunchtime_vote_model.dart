import 'dart:convert';

class LunchtimeVoteModel {
  final String voteDate;
  final dynamic voteStartDateTime;
  final dynamic voteEndDateTime;
  final int voteCount;
  final String voteNotice;
  final bool isShowingResult;
  final List<int> result;
  final List<LunchtimeSubVoteModel> subVotes;

  LunchtimeVoteModel(
      {this.voteDate,
      this.voteStartDateTime,
      this.voteEndDateTime,
      this.voteCount,
      this.voteNotice,
      this.isShowingResult,
      this.result,
      this.subVotes});

  LunchtimeVoteModel.fromData(
    Map<String, dynamic> data,
    List<LunchtimeSubVoteModel> subVotesList,
  )   : voteDate = data['voteDate'],
        voteStartDateTime = data['voteStartDateTime'],
        voteEndDateTime = data['voteEndDateTime'],
        voteNotice = data['voteNotice'],
        voteCount = data['voteCount'],
        isShowingResult = data['isShowingResult'],
        result = data['result'] == null ? [] : data['result'].cast<int>(),
        subVotes = subVotesList;

  // VoteModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'voteDate': this.voteDate,
      'voteStartDateTime': this.voteStartDateTime,
      'voteEndDateTime': this.voteEndDateTime,
      'voteCount': this.voteCount,
      'voteNotice': this.voteNotice,
      'isShowingResult': this.isShowingResult,
      'voteResult': this.result,
    };
  }
}

class LunchtimeSubVoteModel {
  final String name;
  final String indexOrStocks;
  final String issueCode;
  final String marketCode;
  final num basePrice;

  LunchtimeSubVoteModel({
    this.name,
    this.indexOrStocks,
    this.issueCode,
    this.marketCode,
    this.basePrice,
  });

  LunchtimeSubVoteModel copyWith({
    String name,
    String indexOrStocks,
    String issueCode,
    String marketCode,
    num basePrice,
  }) {
    return LunchtimeSubVoteModel(
      name: name ?? this.name,
      indexOrStocks: indexOrStocks ?? this.indexOrStocks,
      issueCode: issueCode ?? this.issueCode,
      marketCode: marketCode ?? this.marketCode,
      basePrice: basePrice ?? this.basePrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'indexOrStocks': indexOrStocks,
      'issueCode': issueCode,
      'marketCode': marketCode,
      'basePrice': basePrice,
    };
  }

  factory LunchtimeSubVoteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LunchtimeSubVoteModel(
      name: map['name'],
      indexOrStocks: map['indexOrStocks'],
      issueCode: map['issueCode'],
      marketCode: map['marketCode'],
      basePrice: map['basePrice'],
    );
  }

  @override
  String toString() {
    return 'LunchtimeVoteModel(name: $name, indexOrStocks: $indexOrStocks, issueCode: $issueCode, marketCode: $marketCode, basePrice: $basePrice)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LunchtimeSubVoteModel &&
        o.name == name &&
        o.indexOrStocks == indexOrStocks &&
        o.issueCode == issueCode &&
        o.marketCode == marketCode &&
        o.basePrice == basePrice;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        indexOrStocks.hashCode ^
        issueCode.hashCode ^
        marketCode.hashCode ^
        basePrice.hashCode;
  }
}
