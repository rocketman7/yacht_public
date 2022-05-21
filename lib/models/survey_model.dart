import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/settings/one_on_one_view_model.dart';

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

// 테스트용 서베이 퀘스트
// QuestModel userSurveyQuestTemplate = QuestModel(
//   category: '특별 퀘스트',
//   closeHomeDateTime: null,
//   expParticipationReward: 10,
//   imageUrl: 'illust/factory.png',
//   investAddresses: null,
//   isYachtPointOneOfN: false,
//   itemNeeded: 0,
//   leagueId: 'allTime',
//   leaguePointSuccessReward: 0,
//   liveEndDateTime: null,
//   liveStartDateTime: null,
//   questDescription: "설문조사에 참여해주세요",
//   questEndDateTime: null,
//   questStartDateTime: null,
//   resultDateTime: null,
//   rewardDescription: "모두에게 요트 포인트 500점을 드립니다",
//   selectInstruction: "요트 유저 설문",
//   selectMode: 'survey',
//   showHomeDateTime: DateTime(2022, 5, 4, 0, 0, 0),
//   surveys: newUserSurvey,
//   themeColor: "FFF3D3",
//   title: "요트 유저 설문",
//   uploadDateTime: DateTime(2022, 5, 4, 0, 0, 0),
//   yachtPointParticipationReward: 500,
//   yachtPointSuccessReward: 0,
//   counts: 0,
//   basePriceInstruction: '',
//   questId: 'dd',
// );

// List<SurveyQuestionModel> newUserSurvey = [
//   SurveyQuestionModel(
//     pageType: 'instruction',
//     answerType: 'none',
//     question:
//         '안녕하세요! 요트 운영진입니다. \n\n유저분들의 만족도 조사 및 향후 개선 사항을 파악해 더 발전된 요트가 되기 위한 간략한 설문을 준비해보았어요. \n\n설문에 참여해주신 분께는 500 요트포인트를 소정의 선물로 드리오니 잠시만 시간을 내주시어 꼭 참여해주시면 감사하겠습니다! \n(예상 소요시간: 2분)',
//     answers: null,
//   ),
//   SurveyQuestionModel(
//       answersId: 0,
//       pageType: 'survey',
//       answerType: 'pickOne',
//       question: '요트를 사용한 경험이 만족스러운가요?',
//       answers: ['만족', '보통', '아쉬움']),
//   SurveyQuestionModel(
//     answersId: 1,
//     pageType: 'survey',
//     answerType: 'pickOrSentence',
//     question: '요트의 기능 중 가장 만족스러운 기능은 무엇인가요?',
//     answers: ['예측 퀘스트와 보상', '퀘스트 주식 및 상금 주식의 기업 소개', '요트 매거진 콘텐츠', '유저 커뮤니티', '기타'],
//   ),
//   SurveyQuestionModel(
//       answersId: 2,
//       pageType: 'survey',
//       answerType: 'pickOrSentence',
//       question: '요트를 사용하며 느끼는 가장 아쉬운 점은 무엇인가요?.(복수 선택 가능)',
//       answers: ['퀘스트 보상', '요트 매거진 컨텐츠', '커뮤니티', '앱의 디자인', '기타']),
//   SurveyQuestionModel(
//       answersId: 3,
//       pageType: 'survey',
//       answerType: 'pickOrSentence',
//       question: '요트에 추가되면 좋을 것들을 선택해주세요.(복수 선택 가능)',
//       answers: [
//         '주제/종목별 채팅방 기능',
//         '실시간 국내외 주식 가격 정보',
//         '요트가 선정한 이 주의 종목 소개',
//         '투자자산 공유하기',
//         '기타(주관식 응답, 짧아도 괜찮아요!)',
//       ]),
//   SurveyQuestionModel(
//       answersId: 4,
//       pageType: 'survey',
//       answerType: 'pickOrSentence',
//       question: '증권사 앱 이외에 사용하고 있는 투자 관련 앱이나 서비스가 있나요?',
//       answers: ['없어요', '있어요']),
//   SurveyQuestionModel(
//       answersId: 5,
//       pageType: 'survey',
//       answerType: 'pickOrSentence',
//       question: '주식 이외에 가장 관심있는 투자 자산은? (복수 선택 가능)',
//       answers: [
//         '가상화폐',
//         '채권',
//         '부동산',
//         '미술품',
//         '기타(주관식 응답, 짧아도 괜찮아요!)',
//       ]),
//   SurveyQuestionModel(
//       answersId: 6,
//       pageType: 'survey',
//       answerType: 'pickOrSentence',
//       question: '투자를 하며 느끼는 가장 어려운 점은 무엇인가요?',
//       answers: [
//         '새로운 종목 발굴',
//         '매수/매도 시점 결정',
//         '자산 배분 방법',
//         '기타(주관식 응답, 짧아도 괜찮아요!)',
//       ]),
//   SurveyQuestionModel(
//       answersId: 7,
//       pageType: 'survey',
//       answerType: 'pickOrSentence',
//       question: '요트 운영진에게 하고 싶은 말을 자유롭게 적어주세요.',
//       answers: [
//         '요트에게 바랍니다!',
//       ]),
//   // SurveyQuestionModel(
//   //     answersId: 8,
//   //     pageType: 'survey',
//   //     answerType: 'pickOrSentence',
//   //     question: '요트에 더 바라는 점이나 아쉬운 점이 있으시면 자유롭게 적어주세요',
//   //     answers: [
//   //       '요트에 바랍니다!',
//   //     ]),
//   SurveyQuestionModel(
//     answersId: 8,
//     pageType: 'survey',
//     answerType: 'pickOrSentence',
//     question:
//         '요트의 발전을 위한 추후 심층 비대면 인터뷰에 응해주실 의향이 있으시다면, 이메일을 적어주세요. \n적어주신 분들 중 일부에게 따로 연락드리어 인터뷰를 요청드리겠습니다!\n비대면 인터뷰에 참여해주신 유저분들께는 2만원 상당의 상품권을 드립니다.(예상 소요시간: 30분)',
//     answers: [
//       '설문에만 참여할게요.',
//       '심층 비대면 인터뷰에 참여할래요!',
//     ],
//     isFinal: true,
//   ),
//   SurveyQuestionModel(
//     pageType: 'instruction',
//     answerType: 'none',
//     question: '참여해주셔서 감사합니다!\n아래 설문 완료버튼을 누르고 요트 포인트를 받으세요:)',
//     answers: null,
//     instruction: "설문 완료",
//     // isFinal: true,
//   )
// ];

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
