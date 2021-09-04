// 필요한 이것저것들. 당장 최초 로딩해줄 필요는 없고 나는 마이프로필 접근할 때 로 해놓음
class AdminStandardsModel {
  final List<String> avatarImages;

  AdminStandardsModel({required this.avatarImages});

  factory AdminStandardsModel.fromMap(Map<String, dynamic> map) {
    return AdminStandardsModel(
      avatarImages: List<String>.from(map['avatarImages']),
    );
  }
}
