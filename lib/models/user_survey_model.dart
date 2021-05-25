import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserSurveyModel {
  final String? title;
  final String? description;
  final String? thank;
  final String? endingStatement;
  final List<SurveyQuestionModel> surveyQuestions;
  UserSurveyModel(
    this.title,
    this.description,
    this.thank,
    this.endingStatement,
    this.surveyQuestions,
  );

  UserSurveyModel copyWith({
    String? title,
    String? description,
    String? thank,
    String? endingStatement,
    List<SurveyQuestionModel>? surveyQuestions,
  }) {
    return UserSurveyModel(
      title ?? this.title,
      description ?? this.description,
      thank ?? this.thank,
      endingStatement ?? this.endingStatement,
      surveyQuestions ?? this.surveyQuestions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'thank': thank,
      'endingStatement': endingStatement,
      'surveyQuestions': surveyQuestions.map((x) => x.toJson()).toList(),
    };
  }

  factory UserSurveyModel.fromData(Map<String, dynamic> data,
      List<SurveyQuestionModel> surveyQuestionModel) {
    return UserSurveyModel(
      data['title'],
      data['description'],
      data['thank'],
      data['endingStatement'],
      surveyQuestionModel,
    );
  }

  @override
  String toString() =>
      'UserSurveyModel(title: $title, description: $description, thank : $thank, endingStatement: $endingStatement, surveyQuestions: $surveyQuestions)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserSurveyModel &&
        other.title == title &&
        other.description == description &&
        other.thank == thank &&
        other.endingStatement == endingStatement &&
        listEquals(other.surveyQuestions, surveyQuestions);
  }

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      thank.hashCode ^
      endingStatement.hashCode ^
      surveyQuestions.hashCode;
}

class SurveyQuestionModel {
  final String? question;
  final List<String> answers;
  final bool? multipleChoice;
  final String? shortAnswer;

  SurveyQuestionModel(
    this.question,
    this.answers,
    this.multipleChoice,
    this.shortAnswer,
  );

  SurveyQuestionModel copyWith({
    String? question,
    List<String>? answers,
    bool? multipleChoice,
    String? shortAnswer,
  }) {
    return SurveyQuestionModel(
      question ?? this.question,
      answers ?? this.answers,
      multipleChoice ?? this.multipleChoice,
      shortAnswer ?? this.shortAnswer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers,
      'multipleChoice': multipleChoice,
      'shortAnswer': shortAnswer,
    };
  }

  factory SurveyQuestionModel.fromData(Map<String, dynamic> data) {
    return SurveyQuestionModel(
      data['question'],
      data['answers'] == null ? [] : List<String>.from(data['answers']),
      data['multipleChoice'],
      data['shortAnswer'],
    );
  }

  @override
  String toString() {
    return 'SurveyQuestionModel(question: $question, answers: $answers, multipleChoice: $multipleChoice, shortAnswer: $shortAnswer)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SurveyQuestionModel &&
        other.question == question &&
        listEquals(other.answers, answers) &&
        other.multipleChoice == multipleChoice &&
        other.shortAnswer == shortAnswer;
  }

  @override
  int get hashCode {
    return question.hashCode ^
        answers.hashCode ^
        multipleChoice.hashCode ^
        shortAnswer.hashCode;
  }
}
