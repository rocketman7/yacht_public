class UserModel {
  final String uid;
  final String userName;
  final String email;
  final String phoneNumber;
  final String friendsCode;
  int item;
  final String avatarImage;
  final bool isNameUpdated;

  String accNumber;
  String accName;
  String secName;

  final bool isNameUpdated;
  // final List<UserVote> userVotes;

  UserModel({
    this.uid,
    this.userName,
    this.email,
    this.phoneNumber,
    this.friendsCode,
    this.item,
    this.avatarImage,
    this.isNameUpdated,
    this.accNumber,
    this.accName,
    this.secName,
    this.isNameUpdated,
    // this.userVotes,
  });

  // Json -> UserModel 변환 constructor
  UserModel.fromData(
    Map<String, dynamic> data,
  )   : uid = data['uid'],
        userName = data['userName'],
        email = data['email'],
        phoneNumber = data['phoneNumber'],
        friendsCode = data['friendsCode'],
        item = data['item'],
        avatarImage = data['avatarImage'],
        isNameUpdated = data['isNameUpdated'],
        accNumber = data['account']['accNumber'],
        accName = data['account']['accName'],
        secName = data['account']['secName'],
        isNameUpdated = data['isNameUpdated'];
  // UserModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'email': this.email,
      'phoneNumber': this.phoneNumber,
      'friendsCode': this.friendsCode,
      'item': this.item,
      'avatarImage': this.avatarImage,
      'isNameUpdated': this.isNameUpdated,
      'account': {
        'accNumber': this.accNumber,
        'accName': this.accName,
        'secName': this.secName
      },
      'isNameUpdated': this.isNameUpdated,
    };
  }
}
