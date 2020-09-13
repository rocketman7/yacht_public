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


// exports.accVerify = functions.https.onRequest((req, resp) => {
//   const options = {
//     headers: {
//       'Host': 'datahub-dev.scraping.co.kr',
//       'Authorization': 'Token ed1ff970f8c64e73857026e430dca5484aa2933e',
//       'Content-Length': 118,
//       'Content-Type': 'application/json;charset=UTF-8',
//     }
//   };

//   resp = req.request(options, 'http://datahub-dev.scraping.co.kr/scrap/common/settlebank/accountOwner');
//   resp.send();

//   resp.end();
//   req.end();
//   functions.logger.info("Hello logs!", { structuredData: true });
//   resp.send("Hello from Firebase!");

//   resp.end();
//   req.end();
// });


exports.accVerifys = functions.https.onRequest((req, resp) => {
  // functions.logger.info("Hello logs!", { structuredData: true });
  // response.send("Hello from Firebase!");
  // const options = {
  //   Host: 'datahub-dev.scraping.co.kr',
  //   Authorization: 'Token ed1ff970f8c64e73857026e430dca5484aa2933e',
  // };

  // resp = req.request(options, '/scrap/common/settlebank/accountOwner');
  // resp.send();
  // req = functions.reqPost('https://datahub-dev.scraping.co.kr/scrap/common/settlebank/accountOwner')
  // var https = require('https');

  // var reqPost = https.request('https://datahub-dev.scraping.co.kr/scrap/common/settlebank/accountOwner');

  var http = require('http');

  // Build the post string from an object
  var post_data = JSON.stringify({
        "OID" : null,
        "CUSTID" : "123123",
        "ACCTNO" : "17711040661",
        "BANKCODE" : "278",
        "CUSTNM" : "김세준"
  });

  // An object of options to indicate where to post to
  var post_options = {
    // Host: 'datahub-dev.scraping.co.kr',
    // port: '80',
    Authorization: 'Token ed1ff970f8c64e73857026e430dca5484aa2933e',
    // path: '/scrap/common/settlebank/accountOwner',
    uri: 'https://datahub-dev.scraping.co.kr/scrap/common/settlebank/accountOwner',
    method: 'POST',
    headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Content-Length': Buffer.byteLength(post_data)
    }
  };

  // Set up the request
  var post_req = http.request(post_options, function(res) {
    res.setEncoding('utf8');
    res.on('data', function (chunk) {
        console.log('Response: ' + chunk);
    });
  });

  // post the data
  post_req.write(post_data);
  post_req.end();

  // resp.send(reqPost);

  // jsonObject = JSON.stringify(
  //   {
  //     "OID" : null,
  //     "CUSTID" : "123123",
  //     "ACCTNO" : "17711040661",
  //     "BANKCODE" : "278",
  //     "CUSTNM" : "김세준"
  //   }
  // );

  // var postheaders = {
  //   'Content-Type' : 'application/json;charset=UTF-8',
  //   'Content-Length' : 118
  // };

  // var optionspost = {
  //   Host : 'datahub-dev.scraping.co.kr',
  //   path : '/scrap/common/settlebank/accountOwner',
  //   Authorization : 'Token ed1ff970f8c64e73857026e430dca5484aa2933e',
  //   method : 'POST',
  //   headers : postheaders
  // };

  // var reqPost = https.request(optionspost, function(res) {
  //   console.log("statusCode: ", res.statusCode);
  //   // uncomment it for header details
  //   //  console.log("headers: ", res.headers);

  //   res.on('data', function(d) {
  //       console.info('POST result:\n');
  //       process.stdout.write(d);
  //       console.info('\n\nPOST completed');
  //   });
  // });

  // // write the json data
  // reqPost.write(jsonObject);
  // reqPost.end();
  // reqPost.on('error', function(e) {
  //     console.error(e);
  // });
});