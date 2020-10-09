class OneOnOneModel {
  final bool state;
  final String questionTitle;
  final String questionContent;
  final String answer;

  OneOnOneModel({
    this.state,
    this.questionTitle,
    this.questionContent,
    this.answer,
  });

  OneOnOneModel.fromData(Map<String, dynamic> data)
      : state = data['state'],
        questionTitle = data['questionTitle'],
        questionContent = data['questionContent'],
        answer = data['answer'];

  Map<String, dynamic> toJson() {
    return {
      'state': this.state,
      'questionTitle': this.questionTitle,
      'questionContent': this.questionContent,
      'answer': this.answer,
    };
  }
}
