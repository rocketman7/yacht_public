class UserModel {
  final String uid;
  final String userName;
  final String email;
  final String phoneNumber;
  final int combo;
  // final List<UserVote> userVotes;

  UserModel({
    this.uid,
    this.userName,
    this.email,
    this.phoneNumber,
    this.combo,
    // this.userVotes,
  });

  // Json -> UserModel 변환 constructor
  UserModel.fromData(
    Map<String, dynamic> data,
  )   : uid = data['uid'],
        userName = data['userName'],
        email = data['email'],
        phoneNumber = data['phoneNumber'],
        combo = data['combo'];
  // UserModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'email': this.email,
      'phoneNumber': this.phoneNumber,
      'combo': this.combo,
    };
  }
}
