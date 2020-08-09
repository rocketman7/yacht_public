const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { user } = require("firebase-functions/lib/providers/auth");
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((data, context) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});

// User 데이터에서 combo sorting하여 rank DB에 넣는 함수
exports.sortRank = functions.https.onRequest(async (req, res) => {
  // 1. users의 combo로 sorting해서
  // 2. combo order로 uid를 정렬
  // 3.정렬된 uid를 rank collection에 넣기

  const db = admin.firestore();
  const users = db.collection("users");
  const rank = db.collection("rank");

  //user collection snapshot 넣을 list of Object
  let userDocs = [];
  // snapshot 가져올 때 await 해야 함
  const snapshot = await users.get();
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

  // const rankSnapshot = await rank.doc("MjMBRKk3D2mdBuzhO6wm").get();
  // let rankDocs = [];
  // // rankSnapshot.forEach((doc) => {
  // //   console.log(doc.data());
  // //   rankDocs.push(...doc.data());
  // // });
  // console.log(rankSnapshot);
  // rankDocs = rankSnapshot.data();
  // console.log(rankDocs);
  // // console.log(rankDocs[0]);

  console.log(typeof userDocs);
  console.log(typeof userDocs[0]);
  console.log(userDocs);
  console.log(userDocs[0].combo.toString());

  const today = "20200809";
  let testData = [];

  userDocs.forEach((item, index, arr2) => {
    console.log(item, index, arr2[index + 1]);
    testData.push({
      uid: item[index].uid,
      combo: item[index].combo,
      ranking: index,
      userName: item[index].userName,
    });
  });

  //첫번쨰 인수는 배열의 각각의 item
  //두번쨰 인수는 배열의 index
  //세번째 인수는 배열 그자체

  console.log(testData);
  // const testData = {
  //   combo: userDocs[0].combo,
  //   ranking: 0,
  //   userName: userDocs[0].userName,
  // };

  const pushData = await rank.doc("season001").collection.set(testData[0]);

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

  res.send(userDocs);

  // var usersCombos = await users.get().then((snapshot) => {
  //   let arrayR = snapshot.docs.map((doc) => {
  //     return res.send(doc.data());
  //   });
  //   console.log(arrayR);
  //   return res.json(arrayR);
  // });

  // var snapshot = await users.get();

  // var snapshotObj = await users.get("value", (snapshot) => {
  //   snapshotToArray(snapshot);
  // });

  // res.send(snapshot.docs.map((doc) => doc.data()));
  // snapshot = snapshot.docs.map((doc) => doc.data());

  // var snapObj = JSON.parse(snapshot.docs.map((doc) => doc.data()));
  // usersCombos.sort((a, b) => {
  //   // combo 오름차순
  //   return b["combo"] - a["combo"];
  // });
});
