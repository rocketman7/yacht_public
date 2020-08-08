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

exports.sortRank = functions.https.onRequest(async (req, res) => {
  // 1. users의 combo로 sorting해서
  // 2. combo order로 uid를 정렬
  // 3.정렬된 uid를 rank collection에 넣기
  // function snapshotToArray(snapshot) {
  //   var returnArr = [];

  //   snapshot.forEach((childSnapshot) => {
  //     var item = childSnapshot.val();
  //     item.key = childSnapshot.key;

  //     returnArr.push(item);
  //   });

  //   return returnArr;
  // }
  var db = admin.firestore();
  var users = db.collection("users");

  const snapshot = await users.get();
  res.send(snapshot.docs.map((doc) => doc.data()));

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

  // snapshot.sort((a, b) => {
  //   return b["combo"] - a["combo"];
  // });

  // res.send(snapshot);
});
