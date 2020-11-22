import 'dart:convert';

class StatsModel {
  final num actualEps;
  final num expectedEps;
  final String announcedAt;
  final dynamic uploadedAt;
  StatsModel({
    this.actualEps,
    this.expectedEps,
    this.announcedAt,
    this.uploadedAt,
  });

  StatsModel copyWith({
    num actualEps,
    num expectedEps,
    String announcedAt,
    dynamic uploadedAt,
  }) {
    return StatsModel(
      actualEps: actualEps ?? this.actualEps,
      expectedEps: expectedEps ?? this.expectedEps,
      announcedAt: announcedAt ?? this.announcedAt,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actualEps': actualEps,
      'expectedEps': expectedEps,
      'announcedAt': announcedAt,
      'uploadedAt': uploadedAt,
    };
  }

  factory StatsModel.fromData(Map<String, dynamic> data) {
    if (data == null) return null;

    return StatsModel(
      actualEps: data['actualEps'],
      expectedEps: data['expectedEps'],
      announcedAt: data['announcedAt'],
      uploadedAt: data['uploadedAt'],
    );
  }

  @override
  String toString() {
    return 'StatsModel(actualEps: $actualEps, expectedEps: $expectedEps, announcedAt: $announcedAt, uploadedAt: $uploadedAt)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StatsModel &&
        o.actualEps == actualEps &&
        o.expectedEps == expectedEps &&
        o.announcedAt == announcedAt &&
        o.uploadedAt == uploadedAt;
  }

  @override
  int get hashCode {
    return actualEps.hashCode ^
        expectedEps.hashCode ^
        announcedAt.hashCode ^
        uploadedAt.hashCode;
  }
}
