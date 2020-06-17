# yachtOne

요트원 프로젝트입니다. 6월 8일에 시작했어요.

## 진행 사항

~ 6/13 : 투표 선택 화면 초안과 DB연결 완료  
~ 6/17 : 투표 화면 초안과 DB연결 완료

***
### TODO LIST:

- [ ] BaseModel의 busy처리
- [ ] 각종 네트워크 예외처리
- [ ] Auth 예외처리, 닉네임 중복 방지
- [ ] 코드 정리
- [ ] DateTime <-> String Parser 만들기

---
### 완료된 사항:
- [x] Auth: Email & Password 회원가입, 로그인, 가입 동시에 DB에 User모델 저장
- [x] VoteSelect: 투표 리스트에서 기존 순서대로 투표 <-> 선택한 투표 교환, 
- [x] Vote: VoteSelect에서 선택한 List 가져와서 Vote화면 차례로 표시, 꾸욱-> 투표가 더 있으면 다음 투표, 아니면 댓글 페이지(현재는 홈 화면)