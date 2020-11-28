class FaqModel {
  final String category;
  final String title;
  final String content;

  FaqModel({
    this.category,
    this.title,
    this.content,
  });

  FaqModel.fromData(Map<String, dynamic> data)
      : category = data['category'],
        title = data['title'],
        content = data['content'];

  Map<String, dynamic> toJson() {
    return {
      'category': this.category,
      'title': this.title,
      'content': this.content,
    };
  }
}
