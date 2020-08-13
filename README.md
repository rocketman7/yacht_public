# yachtOne

요트원 프로젝트입니다. 6월 8일에 시작했어요.

---

### TODO LIST:

#### General

- [ ] BaseModel의 busy처리
- [ ] 각종 네트워크 예외처리
- [ ] 코드 정리
- [ ] DateTime <-> String Parser 만들기

#### 로그인/회원가입

- [ ] 구글 로그인 기능
- [ ] userName 중복 방지 기능

#### 꾸욱 페이지

- [ ] 꾸욱 animation

#### 주제별 커뮤니티

- [ ] 투표 차트 -> 투표 통계 데이터가 있어야 함
- [ ] 자신이 쓴 코멘트 수정, 삭제 기능

#### 주제 선택 페이지

- [ ] Tag 기능

---

### Cloud Functions

- [x] 사용자 예측 채점: scoreVote
- [x] 콤보 현황 rank에 넣기: sortRank

---

### 완료된 사항:

- [x] Auth: Email & Password 회원가입, 로그인, 가입 동시에 DB에 User모델 저장
- [x] VoteSelect: 투표 리스트에서 기존 순서대로 투표 <-> 선택한 투표 교환,
- [x] Vote: VoteSelect에서 선택한 List 가져와서 Vote화면 차례로 표시, 꾸욱-> 투표가 더 있으면 다음 투표, 아니면 댓글 페이지(현재는 홈 화면)
- [x] Auth 예외처리
- [x] Dialog Service
