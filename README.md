# yachtOne

요트원 프로젝트입니다. 6월 8일에 시작했어요.

---

### TODO LIST:

#### General

- [ ] BaseModel의 busy처리
- [ ] 각종 네트워크 예외처리
- [ ] 코드 정리
- [ ] 앱 설정 페이지 (푸쉬 알람 등)
- [ ] Bottom Navigation Bar 만들기
- [ ] Top Bar에 들어갈 아이템 관련 팝업 (디자인 확정 이후 UI 작업하되 DB는 미리 준비)
  

- [x] Dialog Service
- [x] DateTime <-> String Parser 만들기 (VoteSelectView, VoteCommentView 에서 다룸)

#### 로그인/회원가입

- [ ] 구글 로그인 기능
- [ ] 휴대폰 본인인증 (twilio, 아임포트(다날pg), 구글 firebase, naver cloud platform 중 골라서 구현)

- [x] userName 중복 방지 기능 (8/14)
- [x] Auth 예외처리
- [x] Auth: Email & Password 회원가입, 로그인, 가입 동시에 DB에 User모델 저장

#### 주제 선택 페이지

- [ ] Tag 기능

- [x] VoteSelect: 투표 리스트에서 기존 순서대로 투표 <-> 선택한 투표 교환,

#### 꾸욱 페이지

- [ ] 꾸욱 animation

- [x] Vote: VoteSelect에서 선택한 List 가져와서 Vote화면 차례로 표시, 꾸욱-> 투표가 더 있으면 다음 투표, 아니면 댓글 페이지(현재는 홈 화면)

#### 주제별 커뮤니티

- [ ] 실시간 주제 종목 데이터

- [x] 투표 차트 -> 투표 통계 데이터가 있어야 함 (8/21)
- [x] 자신이 쓴 코멘트 삭제 기능 완료/ 삭제 재확인 Dialog 처리 완료 (8/16)

---

### Cloud Functions

- [ ] sortRank에서 document 다 지우고 set하기

- [x] numVoted count 기능 (8/19)
- [x] 사용자 예측 채점: scoreVote (8/14)
- [x] 콤보 현황 rank에 넣기: sortRank

---

