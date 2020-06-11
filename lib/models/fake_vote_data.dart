const VOTE_INFO = [
  {
    'voteDate': '20200901',
    'voteCount': 5,
    'voteResult': [1, 2, 1, 1, 2],
  }
];

var startDate = DateTime.utc(2020, 9, 1, 7, 0, 0); // KST 2020/09/01 16:00
var endDate = DateTime.utc(2020, 9, 1, 23, 50, 0); // KST 2020/09/02 08:50

var VOTE_DATA = [
  {
    'title': '9월 2일 코스피 방향은?',
    'voteImg':
        'https://img5.yna.co.kr/photo/yna/YH/2020/01/29/PYH2020012920480032500_P4.jpg',
    'voteStartDate': startDate,
    'voteEndDate': endDate,
    'voteChoices': ['상승', '하락'],
    'choiceCounts': 2,
    'Result': null
  },
  {
    'title': '9월 2일 수익률 승자는?',
    'voteImg':
        'https://theintercept.imgix.net/wp-uploads/sites/1/2020/03/stockmarket-theintercept-02-1584129333.jpg',
    'voteStartDate': startDate,
    'voteEndDate': endDate,
    'voteChoices': ['네이버', '카카오'],
    'choiceCounts': 2,
    'Result': null
  },
  {
    'title': '9월 2일 환율 방향은?',
    'voteImg':
        'https://thenypost.files.wordpress.com/2020/03/sized-nyse-march-18.jpg',
    'voteStartDate': startDate,
    'voteEndDate': endDate,
    'voteChoices': ['상승', '하락'],
    'choiceCounts': 2,
    'Result': null
  },
  {
    'title': '9월 2일 수익률 승자는?',
    'voteImg': 'https://www.abc.net.au/cm/rimage/9395060-3x2-xlarge.jpg',
    'voteStartDate': startDate,
    'voteEndDate': endDate,
    'voteChoices': ['대웅제약', '일양약품'],
    'choiceCounts': 2,
    'Result': null
  },
  {
    'title': '9월 2일 수익률 승자는?',
    'voteImg':
        'https://knowledge.wharton.upenn.edu/wp-content/uploads/2017/03/Stock-market.jpg',
    'voteStartDate': startDate,
    'voteEndDate': endDate,
    'voteChoices': ['신풍제약', '부광약품'],
    'choiceCounts': 2,
    'Result': null
  },
];
