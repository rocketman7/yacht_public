// 여기서부터가 진짜
const List<String> pushAlarmKey = [
  'pushAlarm1',
  'pushAlarm2',
  'pushAlarm3',
  // 'testPushAlarm' // 테스트용. 반드시 주석처리
];

// avatar의 asset image 주소를 저장
const String avatarKey = 'avatar';

// 각 화면별 튜토리얼 상태저장
// const String portfolioTutorialKey = 'portfolioTutorial';
// const String voteSelectTutorialKey = 'voteSelectTutorial';
const String portfolioTutorialKey = 'portfolioTutorialUsdingCM';
const String voteSelectTutorialKey = 'voteSelectTutorialUsingCM';
const String termsOfUseKey = 'termsOfUse';

// 가입 후 설문을 했는지, 안했는지 저장
const String didSurveyKey = 'didSurvey';

// 알림을 마지막으로 확인한 시간을 저장. 'yyyymmddhhmm' 으로 분 단위까지.
const String lastCheckTimeKey = 'lastCheckTime';

// 알림모달(서베이나 기타 등등)을 마지막으로 확인한 시간을 저장. 'yyyymmddhhmm'으로 분 단위까지.
// 알림모달(서베이나 기타 등등)을 다시 열지 않음 했는지 안했는지.
// 아직 확정은 아님. 다른 방법 더 고민
// 일단 임시로 이번 서베이에 대해서만
const String firstSurveyKey = 'firstSurvey';
