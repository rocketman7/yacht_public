// DB의 stateManager 값을 가져올 Model
class StateManageModel {
  final String state;

  StateManageModel({
    this.state,
  });

  StateManageModel.fromData(Map<String, dynamic> data) : state = data['state'];
}
