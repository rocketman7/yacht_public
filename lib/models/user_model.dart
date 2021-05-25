class UserModel {
  final String? uid;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String? friendsCode;
  final String? insertedFriendsCode;
  int? item;
  int? rewardedCnt;
  final String? avatarImage;

  String? accNumber;
  String? accName;
  String? secName;

  final bool? isNameUpdated;
  List<dynamic>? blockList;
  // final List<UserVote> userVotes;

  UserModel({
    this.uid,
    this.userName,
    this.email,
    this.phoneNumber,
    this.friendsCode,
    this.insertedFriendsCode,
    this.item,
    this.rewardedCnt,
    this.avatarImage,
    this.accNumber,
    this.accName,
    this.secName,
    this.isNameUpdated,
    this.blockList,
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
        insertedFriendsCode = data['insertedFriendsCode'],
        item = data['item'],
        rewardedCnt = data['rewardedCnt'] ?? 0,
        avatarImage = data['avatarImage'],
        accNumber = data['account']['accNumber'],
        accName = data['account']['accName'],
        secName = data['account']['secName'],
        isNameUpdated = data['isNameUpdated'],
        blockList = data['blockList'] ?? [];
  // UserModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'email': this.email,
      'phoneNumber': this.phoneNumber,
      'friendsCode': this.friendsCode,
      'insertedFriendsCode': this.insertedFriendsCode,
      'item': this.item,
      'rewardedCnt': this.rewardedCnt,
      'avatarImage': this.avatarImage,
      'account': {
        'accNumber': this.accNumber,
        'accName': this.accName,
        'secName': this.secName
      },
      'isNameUpdated': this.isNameUpdated,
      'blockList': this.blockList,
    };
  }
}
