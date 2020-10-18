// DB의 stateManager 값을 가져올 Model
class StateManagerModel {
  final String state;
  final List<dynamic> checkPoint;

  StateManagerModel({
    this.state,
    this.checkPoint,
  });

  StateManagerModel.fromData(Map<String, dynamic> data)
      : state = data['state'],
        checkPoint = data['checkPoint'] ?? [];

  Map<String, dynamic> toJson() {
    return {
      'state': this.state,
      'checkPoint': this.checkPoint,
    };
  }
}
