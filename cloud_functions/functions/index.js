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

// User 데이터에서 combo sorting하여 rank DB에 넣는 함수
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
