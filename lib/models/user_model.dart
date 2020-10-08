class UserModel {
  final String uid;
  final String userName;
  final String email;
  final String phoneNumber;
  final int combo;
  final String friendsCode;
  final int item;
  final String avatarImage;
  final int previousRank;
  String accNumber;
  String accName;
  String secName;
  // final List<UserVote> userVotes;

  UserModel({
    this.uid,
    this.userName,
    this.email,
    this.phoneNumber,
    this.combo,
    this.friendsCode,
    this.item,
    this.avatarImage,
    this.previousRank,
    this.accNumber,
    this.accName,
    this.secName,
    // this.userVotes,
  });

  // Json -> UserModel 변환 constructor
  UserModel.fromData(
    Map<String, dynamic> data,
  )   : uid = data['uid'],
        userName = data['userName'],
        email = data['email'],
        phoneNumber = data['phoneNumber'],
        combo = data['combo'],
        friendsCode = data['friendsCode'],
        item = data['item'],
        avatarImage = data['avatarImage'],
        previousRank = data['previousRank'],
        accNumber = data['account']['accNumber'],
        accName = data['account']['accName'],
        secName = data['account']['secName'];
  // UserModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'email': this.email,
      'phoneNumber': this.phoneNumber,
      'combo': this.combo,
      'friendsCode': this.friendsCode,
      'item': this.item,
      'avatarImage': this.avatarImage,
      'previousRank': this.previousRank,
      'account': {
        'accNumber': this.accNumber,
        'accName': this.accName,
        'secName': this.secName
      },
    };
  }
}
