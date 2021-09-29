import 'dart:convert';

import 'package:flutter/foundation.dart';

// class SurveyModel {
//   final String description;
//   final String thank;
//   final String endingStatement;
//   final List<SurveyQuestionModel> surveyQuestions;
// }

class SurveyQuestionModel {
  /// survey, quiz, instruction, quizResult
  final String pageType;

  /// pickOne, pickMany, sentence, pickManyCircles, none
  final String answerType;

  /// 질문이 될 수도 있고 instruction이 될 수도 있음
  final String question;

  /// answer 매칭하기 위한 id
  final int? answersId;
  final List<String>? answers;
  final int? rightAnswer;

  /// 답변에 따라 redirect를 할지? 기본은 false
  final bool? redirect;

  /// redirect가 true면 답변에 따라 redirectQuestionIndex의 목적지로 이동
  final List<int>? redirectQuestionIndex;
  // 값이 있으면 버튼에 해당 텍스트
  final String? instruction;
  // quiz 맞추면 주는 score
  final int? score;
  final Map<String, dynamic>? resultPictureMapping;
  final bool? isFinal;
  SurveyQuestionModel({
    required this.pageType,
    required this.answerType,
    required this.question,
    this.answersId,
    this.answers,
    this.rightAnswer,
    this.redirect,
    this.redirectQuestionIndex,
    this.instruction,
    this.score,
    this.resultPictureMapping,
    this.isFinal,
  });

  SurveyQuestionModel copyWith({
    String? pageType,
    String? answerType,
    String? question,
    int? answersId,
    List<String>? answers,
    int? rightAnswer,
    bool? redirect,
    List<int>? redirectQuestionIndex,
    String? instruction,
    int? score,
    Map<String, dynamic>? resultPictureMapping,
    bool? isFinal,
  }) {
    return SurveyQuestionModel(
      pageType: pageType ?? this.pageType,
      answerType: answerType ?? this.answerType,
      question: question ?? this.question,
      answersId: answersId ?? this.answersId,
      answers: answers ?? this.answers,
      rightAnswer: rightAnswer ?? this.rightAnswer,
      redirect: redirect ?? this.redirect,
      redirectQuestionIndex: redirectQuestionIndex ?? this.redirectQuestionIndex,
      instruction: instruction ?? this.instruction,
      score: score ?? this.score,
      resultPictureMapping: resultPictureMapping ?? this.resultPictureMapping,
      isFinal: isFinal ?? this.isFinal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pageType': pageType,
      'answerType': answerType,
      'question': question,
      'answersId': answersId,
      'answers': answers,
      'rightAnswer': rightAnswer,
      'redirect': redirect,
      'redirectQuestionIndex': redirectQuestionIndex,
      'instruction': instruction,
      'score': score,
      'resultPictureMapping': resultPictureMapping,
      'isFinal': isFinal,
    };
  }

  factory SurveyQuestionModel.fromMap(Map<String, dynamic> map) {
    return SurveyQuestionModel(
      pageType: map['pageType'],
      answerType: map['answerType'],
      question: map['question'],
      answersId: map['answersId'],
      answers: map['answers'] == null ? null : List<String>.from(map['answers']),
      rightAnswer: map['rightAnswer'],
      redirect: map['redirect'],
      redirectQuestionIndex: map['redirectQuestionIndex'] == null ? null : List<int>.from(map['redirectQuestionIndex']),
      instruction: map['instruction'],
      score: map['score'],
      resultPictureMapping:
          map['resultPictureMapping'] == null ? null : Map<String, dynamic>.from(map['resultPictureMapping']),
      isFinal: map['isFinal'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SurveyQuestionModel.fromJson(String source) => SurveyQuestionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SurveyQuestionModel(pageType: $pageType, answerType: $answerType, question: $question, answersId: $answersId, answers: $answers, rightAnswer: $rightAnswer, redirect: $redirect, redirectQuestionIndex: $redirectQuestionIndex, instruction: $instruction, score: $score, resultPictureMapping: $resultPictureMapping, isFinal:$isFinal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SurveyQuestionModel &&
        other.pageType == pageType &&
        other.answerType == answerType &&
        other.question == question &&
        other.answersId == answersId &&
        listEquals(other.answers, answers) &&
        other.rightAnswer == rightAnswer &&
        other.redirect == redirect &&
        listEquals(other.redirectQuestionIndex, redirectQuestionIndex) &&
        other.instruction == instruction &&
        other.score == score &&
        mapEquals(other.resultPictureMapping, resultPictureMapping) &&
        other.isFinal == isFinal;
  }

  @override
  int get hashCode {
    return pageType.hashCode ^
        answerType.hashCode ^
        question.hashCode ^
        answersId.hashCode ^
        answers.hashCode ^
        rightAnswer.hashCode ^
        redirect.hashCode ^
        redirectQuestionIndex.hashCode ^
        instruction.hashCode ^
        score.hashCode ^
        resultPictureMapping.hashCode ^
        isFinal.hashCode;
  }
}

// List<SurveyQuestionModel> surveyQuestions = [
//   SurveyQuestionModel(
//     pageType: 'instruction',
//     answerType: 'none',
//     question: '신입항해사에 대해\n알고 싶은 점이 있어요.\n\n몇 가지 질문에\n편하게 답해주세요.',
//     answers: null,
//   ),
//   SurveyQuestionModel(
//       answersId: 0,
//       pageType: 'survey',
//       answerType: 'pickOne',
//       question: '연령대를 선택해주세요.',
//       answers: ['10세 ~ 19세', '20세 ~ 25세', '26세 ~ 35세', '36세 ~ 45세', '46세 ~ 55세', '56세 이상']),
//   SurveyQuestionModel(
//     answersId: 1,
//     pageType: 'survey',
//     answerType: 'pickOne',
//     question: '성별을 선택해주세요.',
//     answers: ['남자', '여자', '대답 안 할래요.'],
//   ),
//   SurveyQuestionModel(
//       answersId: 2,
//       pageType: 'survey',
//       answerType: 'pickOne',
//       question: '주식 투자를 시작한 지 얼마나 되었나요?',
//       answers: [
//         '투자경험 없음',
//         '2년 이하',
//         '2년 이상~ 5년 이하',
//         '5년 이상',
//       ],
//       redirect: true,
//       redirectQuestionIndex: [
//         6,
//         3,
//         3,
//         3,
//       ]),
//   SurveyQuestionModel(
//     answersId: 3,
//     pageType: 'survey',
//     answerType: 'pickOne',
//     question: '주식에 투자하고 계신 투자금 규모는 어느 정도인가요?',
//     answers: [
//       '1천만원 미만',
//       '1천만원 이상 5천만원 미만',
//       '5천만원 이상 1억 미만',
//       '1억 이상',
//     ],
//   ),
//   SurveyQuestionModel(
//     answersId: 4,
//     pageType: 'survey',
//     answerType: 'pickOne',
//     question: '해외 주식 투자 경험이 있나요?',
//     answers: [
//       '있다',
//       '없다',
//     ],
//   ),
//   SurveyQuestionModel(
//     answersId: 5,
//     pageType: 'survey',
//     answerType: 'pickOne',
//     question: '투자 자산을 어떻게 배분하고 있나요?',
//     answers: [
//       '예금적금과 주식',
//       '주식 위주, 가상화폐 부동산 투자 등 새로운 투자 의향 있음',
//       '다양한 투자자산에 새로운 투자 의향 있음',
//     ],
//   ),
//   SurveyQuestionModel(
//     pageType: 'instruction',
//     answerType: 'none',
//     question: '다음은 투자 지식 퀴즈예요.\n투자에 대해 얼마나 알고 있는 지\n간단하게 체크해볼까요?',
//     answers: null,
//   ),
//   SurveyQuestionModel(
//     answersId: 6,
//     pageType: 'quiz',
//     answerType: 'pickOne',
//     question: '주가가 그 회사 1주당 수익의 몇 배가 되는가를 나타내는 지표이며, 주가를 주당 순이익(EPS)으로 나누어 계산한 이 지표는 무엇일까요?',
//     answers: [
//       'PBR',
//       'PER',
//       'EBITDA',
//       'EPS',
//     ],
//     rightAnswer: 0,
//   ),
//   SurveyQuestionModel(
//     answersId: 7,
//     pageType: 'quiz',
//     answerType: 'pickOne',
//     question: '2. 의결권이 없는 대신 보통주보다 이익배당 우선순위가 높은 주식을 의미하는 단어는 무엇일까요?',
//     answers: [
//       '배당주',
//       '보통주',
//       '우량주',
//       '우선주',
//     ],
//     rightAnswer: 3,
//   ),
//   SurveyQuestionModel(
//     answersId: 8,
//     pageType: 'survey',
//     answerType: 'pickManyCircles',
//     question: '마지막으로, 어떤 일을 하는 회사인지 아는 종목을 모두 골라주세요.',
//     answers: [
//       '삼성전자',
//       'LG화학',
//       '카카오뱅크',
//       '키네마스터',
//       '삼성전자',
//       'LG화학',
//       '카카오뱅크',
//       '키네마스터',
//       '삼성전자',
//       'LG화학',
//       '카카오뱅크',
//       '키네마스터',
//       '삼성전자',
//       'LG화학',
//       '카카오뱅크',
//       '키네마스터',
//       '삼성전자',
//       'LG화학',
//       '카카오뱅크',
//       '키네마스터',
//       '삼성전자',
//       'LG화학',
//       '카카오뱅크',
//       '키네마스터',
//     ],
//   ),
//   SurveyQuestionModel(
//     pageType: 'instruction',
//     answerType: 'none',
//     question: '참여해주셔서 감사합니다!\n이제 결과를 확인해볼까요?',
//     answers: null,
//   ),
// ];
