const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { user } = require("firebase-functions/lib/providers/auth");
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});

// 1) 사용자들 투표 채점, 2) 사용자 콤보 넣고 빼주고, 3) 랭킹 컬렉션에 순서대로 순위 넣어주고

exports.scoreVote = functions.https.onRequest(async (req, res) => {
  const db = admin.firestore();
  // votes -> docu id: date -> voteResult array
  const votes = db.collection("votes");
  const users = db.collection("users");
  const today = "20200901";

  // today의 실제 결과 가져오기 (이전에 넣어야함)
  let todayResult = [];
  const resultSnapshot = await votes.doc(today).get();
  todayResult = resultSnapshot.data().voteResult; // [1, 2, 2, 1, 2]

  // user의 vote 선택 가져오기

  let userCurrentCombo = {};
  let userVotes = {};
  let userScores = {};

  const userSnapshot = await users.get();
  // userSnapshot에서 각 user의 uid를 리스트로 만듬
  userSnapshot.forEach((doc) => {
    userCurrentCombo[doc.id] = doc.data().combo;
  });

  // userCurrentCombo array로부터 userVote sub-col의 사용자 선택 가져와서 dictionary로 만들기
  async function getEachUserVotesAndMakeDict(datas) {
    await Promise.all(
      datas.map((data) =>
        users
          .doc(data)
          .collection("userVote")
          .doc(today)
          .get()
          .then((doc) => {
            userVotes[data] = doc.data().voteSelected;
            console.log(userVotes);
            return userVotes;
          })
      )
    );
    return userVotes;
  }

  // 사용자 투표 데이터
  allUserVotesDict = await getEachUserVotesAndMakeDict(
    Object.keys(userCurrentCombo)
  );
  //{ m2UUvxsAwfdLFP4RB8q4SgkaNgr2: [ 2, 0, 2, 0, 0 ],
  // itz7XAIaPxSOKrI7MFGEB6LgaBL2: [ 1, 0, 2, 0, 0 ],
  // w9E2tSET3fTrtMoSB7ctTgWlGAO2: [ 0, 2, 2, 0, 0 ] }

  // console.log("final console.log" + allUserVotesDict["itz7XAIaPxSOKrI7MFGEB6LgaBL2"]);

  function scoreUserVotes(userVoteArr, resultArr) {
    var score = 0;
    for (var i = 0; i < resultArr.length; i++) {
      if (userVoteArr[i] !== 0) {
        if (userVoteArr[i] === resultArr[i]) {
          score += 1;
        } else {
          score -= 1;
        }
      } else {
        score += 0;
      }
      console.log("%d번 째 문제 현재 점수 %d", i, score);
    }
    return score;
  }

  for (let uid in allUserVotesDict) {
    score = scoreUserVotes(allUserVotesDict[uid], todayResult);
    userScores[uid] = score;
  }
  // testScore = scoreUserVotes([0, 1, 1, 0, 2], [1, 2, 2, 1, 2]);
  // console.log("test Score is " + testScore);

  // user collection에서 각 uid를 찾아 들어가 combo field 업데이트
  async function updateUserCombo(datas) {
    await Promise.all(
      Object.keys(datas).map((uid) => {
        let newCombo = userCurrentCombo[uid] + datas[uid];
        // newCombo = userSnapshot.doc(uid).data().combo + datas[uid];
        console.log(uid);

        console.log(uid + " new Combo will be " + newCombo);
        if (newCombo < 0) {
          newCombo = 0;
        }
        users.doc(uid).update({ combo: newCombo });
        return 0;
      })
    );
  }

  await updateUserCombo(userScores);

  console.log(Object.keys(allUserVotesDict).length);
  console.log(userScores);
  res.send(userCurrentCombo);
});

// 3) User 데이터에서 combo sorting하여 rank DB에 넣는 함수
exports.sortRank = functions.https.onRequest(async (req, res) => {
  // 1. users의 combo로 sorting해서
  // 2. combo order로 uid를 정렬
  // 3.정렬된 uid를 rank collection에 넣기

  // db와 collection references
  const db = admin.firestore();
  const users = db.collection("users");
  const rank = db.collection("rank");

  //user collection snapshot 넣을 list of Object
  let userDocs = [];
  // snapshot 가져올 때 await 해야 함
  const snapshot = await users.get();
  // 가져온 snapshot을 userDocs array에 dictionary 형태로 추가
  snapshot.forEach((doc) => {
    console.log(doc.data());
    userDocs.push(doc.data());
  });

  console.log(userDocs);
  // res.send(snapshot.docs.map((doc) => doc.data()));

  // combo 내림차순
  userDocs.sort((a, b) => {
    return b["combo"] - a["combo"];
  });

  // console.log(typeof userDocs);
  // console.log(userDocs.length);
  // console.log(userDocs[0].combo.toString());

  // collection id가 될 날짜 지정
  const today = "20200809";
  // rank collection에 넣을 array setting
  let rankData = [];

  // userDocs -> rank collection에 넣을 데이터로 만들어서 rankData array에 넣어줌
  for (var i = 0; i < userDocs.length; i++) {
    rankData.push({
      uid: userDocs[i].uid,
      combo: userDocs[i].combo,
      userName: userDocs[i].userName,
    });
  }

  console.log(rankData);
  console.log(rankData[0]);

  // firebase db에 일괄로 밀어 넣는 함수. 가장 빠름.
  async function testParallelIndividualWrites(datas) {
    // collection 전체 일괄 삭제하려면 promise나 batch 사용해야 함
    // await rank.doc("season001").collection(today).delete();
    await Promise.all(
      datas.map((data) => rank.doc("season001").collection(today).add(data))
    );
  }
  // add는 document id 지정 필요없음
  // set은 document id 지정 필수

  testParallelIndividualWrites(rankData);

  // Sort된 userDocs snapshot
  //   userDocs = [
  //               { uid: 'm2UUvxsAwfdLFP4RB8q4SgkaNgr2',
  //                 email: 'csejun@apple.com',
  //                 combo: 32,
  //                 userName: 'csejun' },
  //               { combo: 27,
  //                 uid: 'itz7XAIaPxSOKrI7MFGEB6LgaBL2',
  //                 userName: 'davidbowie',
  //                 email: 'davidbowie@apple.com' },
  //               { uid: 'w9E2tSET3fTrtMoSB7ctTgWlGAO2',
  //                 email: 'rocketman@apple.com',
  //                 userName: 'rocketman',
  //                 combo: 21 }
  //  ]

  res.send(rankData);
});