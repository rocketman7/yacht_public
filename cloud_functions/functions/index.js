const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Telegraf } = require('telegraf')
const { user } = require("firebase-functions/lib/providers/auth");
// const kakao = require("./kakao");
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

var dateFormat = require("dateformat");
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.region('asia-northeast3').https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});

// 1) 사용자들 투표 채점, 2) 사용자 콤보 넣고 빼주고, 3) 랭킹 컬렉션에 순서대로 순위 넣어주고
exports.scoreVote = functions.region('asia-northeast3').https.onRequest(async (req, res) => {
  const db = admin.firestore();

  // votes -> docu id: date -> voteResult array

  const adminRef = db.collection("admin");
  const votesRef = db.collection("votes");
  const usersRef = db.collection("users");
  // const ranksRef = db.collection("ranks");

  const openSeasonSnapshot = await adminRef.doc("openSeason").get();
  const category = openSeasonSnapshot.data().category;

  const season = openSeasonSnapshot.data().season;
  const votesSeasonCollection = votesRef.doc(category).collection(season);

  // today -> string으로 변환
  // var today = Date();
  var today = dateFormat(Date(), "yyyymmdd");
  // var today = '20210603';
  console.log(today);
  // const today = "20201005";
  // today의 실제 결과 가져오기 (이전에 넣어야함)

  // var today = "20201214";

  function userVotesSeasonCollection(uid) {
    return usersRef
      .doc(uid)
      .collection("userVote")
      .doc(category)
      .collection(season)
      .doc(today);
  }

  function userVotesSeasonStatsCollection(uid) {
    return usersRef
      .doc(uid)
      .collection("userVote")
      .doc(category)
      .collection(season)
      .doc("stats");
  }

  // const todayRankCollectionRef = ranksRef
  //   .doc(category)
  //   .collection(season)
  //   .doc(today)
  //   .collection(today);

  // const prevRankCollectionRef = ranksRef
  //   .doc(category)
  //   .collection(season)
  //   .doc(yeseterday)
  //   .collection(yeseterday);

  // const dailyVoteSnapshot = votesSeasonCollection.doc(today).get();

  // TODAY RESULT***
  let todayResult = [];
  todayResult = await votesSeasonCollection
    .doc(today)
    .get()
    .then((doc) => doc.data().result); // [1, 2, 2, 1, 2]


    // 임의로 result 넣기
  // let todayResult = [2,2,2];
  // user의 vote 선택 가져오기
  console.log(todayResult);
  // let userCurrentCombo = {};
  let userVotes = {};
  let userScores = {};

  let allUsers = {};
  let allUserUid = [];

  // let prevRanks = {};
  // let userPrevWinPoint = {};
  var userSnapshot = await usersRef.get();
  userSnapshot.forEach((doc) => {
    allUsers[doc.id] = doc.data();
  });
  // 모든 유저의 uid를 allUsers 리스트에 저장
  userSnapshot.forEach((doc) => {
    allUserUid.push(doc.id);
  });

  // var prevRankSnapshot = await prevRankCollectionRef.get();

  // prevRankSnapshot.forEach((doc) => {
  //   prevRanks[doc.data().uid] = doc.data().todayRank;
  // });
  function compareArray(arr1, arr2) {
 
    // 결과값
    var rst = false;
 
    // 길이가 다르면 다른 배열이라고 판단
    if (arr1.length !== arr2.length) {
        return rst;
    }
 
    // arr1 배열의 크기만큼 반복
    arr1.forEach((item) => {
 
        // arr1 배열 아이템이, arr2 배열에 있는지 확인
        // 있으면, arr2에 item이 존재하는 index 리턴
        // 없으면, -1 리턴
        var i = arr2.indexOf(item);
 
        // 존재하면, splice함수를 이용해서 arr2 배열에서 item 삭제
        if (i > -1) arr2.splice(i, 1);
    });
 
    // compare2의 길이가 0이면 동일하다고 판단.
    rst = arr2.length === 0;
 
    return rst;
}




  // uid 로 각 유저 오늘의 투표 voteSelected 리스트 return
  async function getEachUserVote(datas) {
    await Promise.all(
      datas.map((uid) =>
        userVotesSeasonCollection(uid)
          .get()
          .then((doc) => {

            
            // console.log(data);
            // isVoted가 true인 것만 골라도 됨
            if (
              doc.data() !== undefined &&
              doc.data() !== null &&
              doc.data().voteSelected !== undefined &&
              doc.data().voteSelected !== null &&
              !compareArray(doc.data().voteSelected, [0,0,0]) 
            ) {
              // console.log(doc.data());
              userVotes[uid] = doc.data().voteSelected;
            }
            return userVotes;
          })
      )
    );
    return userVotes;
  }
  // allUsers 리스트 안의 각 uid를 인자로
  // 각 uservote의 voteSelected를 userVotes에 넣는 함수
await getEachUserVote(allUserUid);
  console.log(userVotes.length);

  // userCurrentCombo array로부터 userVote sub-col의 사용자 선택 가져와서 dictionary로 만들기
  // async function getEachUserVotesAndMakeDict(datas) {
  //   await Promise.all(
  //     datas.map((data) =>
  //       users
  //         .doc(data)
  //         .collection("userVote")
  //         .doc(today)
  //         .get()
  //         .then((doc) => {
  //           userVotes[data] = doc.data().voteSelected;
  //           console.log(userVotes);
  //           return userVotes;
  //         })
  //     )
  //   );
  //   return userVotes;
  // }

  // 사용자 투표 데이터
  // allUserVotesDict = await getEachUserVotesAndMakeDict(
  //   Object.keys(userCurrentCombo)
  // );
  //{ m2UUvxsAwfdLFP4RB8q4SgkaNgr2: [ 2, 0, 2, 0, 0 ],
  // itz7XAIaPxSOKrI7MFGEB6LgaBL2: [ 1, 0, 2, 0, 0 ],
  // w9E2tSET3fTrtMoSB7ctTgWlGAO2: [ 0, 2, 2, 0, 0 ] }

  // console.log("final console.log" + allUserVotesDict["itz7XAIaPxSOKrI7MFGEB6LgaBL2"]);

  function scoreUserVotes(userVoteArr, resultArr) {
    var score = 0;
    for (var i = 0; i < resultArr.length; i++) {
      if (userVoteArr[i] !== 0) {
        if (userVoteArr[i] === resultArr[i]) {
          score += 2;
        } else if (resultArr[i] === 0) {
          score += 0;
        } else {
          score -= 1;
        }
      } else {
        score += 0;
      }
      // console.log("%d번 째 문제 현재 점수 %d", i, score);
    }

    return score;
  }

  // userScores Object에 uid:score 로 매핑
  Object.keys(userVotes).forEach((data) => {
    // console.log(data);
    // console.log(userVotes[data]);
    userScores[data] = scoreUserVotes(userVotes[data], todayResult);
  });

  // for (let uid in userVotes) {
  //   score = scoreUserVotes(userVotes[uid], todayResult);
  //   userScores[uid] = score;
  // }
  // testScore = scoreUserVotes([0, 1, 1, 0, 2], [1, 2, 2, 1, 2]);
  // console.log("test Score is " + testScore);

  //{"nOsN2xoEFiPhWiCvyiSuwZXbbSt1":-3,
  // "m2UUvxsAwfdLFP4RB8q4SgkaNgr2":3,
  // "HPyTUH8vU0fFzssMtmttCdTodLA2":3,
  // "JRwNWkUQuBWJ6HDd0xXDbf3XIjp2":-1}

  // user collection에서 각 uid를 찾아 들어가 combo field 업데이트
  async function updateUserScore(datas) {
    await Promise.all(
      Object.keys(datas).map((uid) => {
        // let userScore =  datas[uid];
        // newCombo = userSnapshot.doc(uid).data().combo + datas[uid];
        // console.log(uid);

        console.log(uid + " 's today score will be" + datas[uid]);
        // userVotesSeasonCollection(uid).update({ score: 0 });
        userVotesSeasonCollection(uid).update({ score: datas[uid] });
        return 0;
      })
    );
  }
  // 주석 풀 곳 
  // await updateUserScore(userScores);

  // winPointHistory 넣기 테스트
  // await userVotesSeasonStatsCollection('kakao:1513684681').update({[`winPointHistory.${today}`] : 9});

  async function updateWinPointForTodayVotedUser(datas) {
    await Promise.all(
      Object.keys(datas).map((uid) =>
        userVotesSeasonStatsCollection(uid)
          .get()
          .then((doc) => {

            // console.log(data);
            // const increment = firebase.firestore.FieldValue.increment(userScores[uid]);
            userVotesSeasonStatsCollection(uid).update({
              
              // currentWinPoint:0,
              currentWinPoint:
                ((doc.data() === undefined ||
                doc.data() === null ||
                doc.data().currentWinPoint === null ||
                doc.data().currentWinPoint === undefined)
                  ? 0 + userScores[uid]
                  : doc.data().currentWinPoint + userScores[uid]) < 0
                  ? 0
                  : (doc.data() === undefined ||
                    doc.data() === null ||
                    doc.data().currentWinPoint === null ||
                    doc.data().currentWinPoint === undefined)
                  ? 0 + userScores[uid]
                  : doc.data().currentWinPoint + userScores[uid],
              updatedAt: today,
              // [`winPointHistory.${today}`] : 0,
              [`winPointHistory.${today}`] : userScores[uid],
            });
           
            return 0;
          })
      )
    );
  }

    // 주석 풀 곳 
  // await updateWinPointForTodayVotedUser(userScores);

  // async function updateCurrentWinPointAtUserVoteStats(
  //   userPrevWinPoint,
  //   userScores,
  //   allUsers
  // ) {
  //   await Promise.all(
  //     Object.keys(userScores).map((uid) => {
  //       var prevWinPoint =
  //         userPrevWinPoint[uid] === null || userPrevWinPoint[uid] === undefined
  //           ? 0
  //           : userPrevWinPoint[uid];

  //       var updatedWinPoint =
  //         userPrevWinPoint[uid] === null || userPrevWinPoint[uid] === undefined
  //           ? 0 + userScores[uid]
  //           : userPrevWinPoint[uid] + userScores[uid];
  //       if (updatedWinPoint < 0) {
  //         updatedWinPoint = 0;
  //       }
  //       //user stat에 currentWinPoint에 업데이트
  //       userVotesSeasonStatsCollection(uid).update({
  //         currentWinPoint: updatedWinPoint,
  //         updatedAt: today,
  //       });

  //       return 0;
  //     })
  //   );
  // }

  // await updateCurrentWinPointAtUserVoteStats(
  //   userPrevWinPoint,
  //   userScores,
  //   allUsers
  // );

  res.send(userScores);
});

// 3) User 데이터에서 combo sorting하여 rank DB에 넣는 함수
exports.sortRank = functions.region('asia-northeast3').https.onRequest(async (req, res) => {
  // 1. users의 combo로 sorting해서
  // 2. combo order로 uid를 정렬
  // 3.정렬된 uid를 rank collection에 넣기

  // db와 collection references
  const db = admin.firestore();

  const adminRef = db.collection("admin");
  const usersRef = db.collection("users");
  const ranksRef = db.collection("ranks");
  const votesRef = db.collection("votes");

  const openSeasonSnapshot = await adminRef.doc("openSeason").get();
  const category = openSeasonSnapshot.data().category;
  const season = openSeasonSnapshot.data().season;

  // const today = "20210714";
  var today = dateFormat(Date(), "yyyymmdd");
  const yesterday = "20210825";
  // todayRankRef

  const seasonInfoRef = votesRef
    .doc(category)
    .collection(season)
    .doc("seasonInfo");

  const seasonStartDate = await seasonInfoRef
    .get()
    .then((doc) => doc.data().startDate);

  function dateRankCollectionRef(date) {
    return ranksRef.doc("KR").collection(season).doc(date).collection(date);
  }

  function userVotesSeasonStatsCollection(uid) {
    return usersRef
      .doc(uid)
      .collection("userVote")
      .doc(category)
      .collection(season)
      .doc("stats");
  }

  let participatedUserSortedCurrentWinPoint = [];
  let allUsers = {};

  const userSnapshot = await usersRef.get();

  userSnapshot.forEach((doc) => {
    allUsers[doc.id] = doc.data();
  });

  // userVote -> season -> stats -> currentWinPoint !== null인 애들만
  async function getAllUserVoteStats(datas) {
    await Promise.all(
      Object.keys(datas).map((uid) =>
        userVotesSeasonStatsCollection(uid)
          .get()
          .then((statsData) => {
            // console.log(statsData.data())
            if (
              statsData.data() !== undefined &&
              statsData.data() !== null &&
              statsData.data().currentWinPoint !== undefined &&
              statsData.data().currentWinPoint !== null 
              // statsData !== null &&
              // statsData !== undefined
            )   
            {
              // console.log(statsData.data());

              var temp = {};
              temp["uid"] = uid;
              temp["currentWinPoint"] = statsData.data().currentWinPoint;
              // temp["avatarImage"] = datas.avatarImage;
              // temp["userName"] = datas.userName;

              // var temp = {};
              // temp[uid] = statsData.data().currentWinPoint;
              participatedUserSortedCurrentWinPoint.push(temp);
            }
            return participatedUserSortedCurrentWinPoint;
          })
      )
    );
    return participatedUserSortedCurrentWinPoint;
  }

  await getAllUserVoteStats(allUsers);
  // console.log(userDocs);
  // res.send(snapshot.docs.map((doc) => doc.data()));

  // combo 내림차순
  participatedUserSortedCurrentWinPoint.sort((a, b) => {
    return b["currentWinPoint"] - a["currentWinPoint"];
  });

  // console.log(typeof userDocs);
  // console.log(participatedUserSortedCurrentWinPoint.length);
  // console.log(participatedUserSortedCurrentWinPoint);

  for (i = 0; i < participatedUserSortedCurrentWinPoint.length; i++) {
    participatedUserSortedCurrentWinPoint[i]["avatarImage"] =
      allUsers[participatedUserSortedCurrentWinPoint[i].uid].avatarImage;

    participatedUserSortedCurrentWinPoint[i]["userName"] =
      allUsers[participatedUserSortedCurrentWinPoint[i].uid].userName;
  }

  for (i = 0; i < participatedUserSortedCurrentWinPoint.length; i++) {
    if (i === 0) {
      participatedUserSortedCurrentWinPoint[i]["todayRank"] = i + 1;
    } else if (
      participatedUserSortedCurrentWinPoint[i].currentWinPoint ===
      participatedUserSortedCurrentWinPoint[i - 1].currentWinPoint
    ) {
      participatedUserSortedCurrentWinPoint[i]["todayRank"] =
        participatedUserSortedCurrentWinPoint[i - 1].todayRank;
    } else {
      participatedUserSortedCurrentWinPoint[i]["todayRank"] = i + 1;
    }
  }

  // console.log(participatedUserSortedCurrentWinPoint.length);
  // console.log(participatedUserSortedCurrentWinPoint);
  // console.log("seasonStart at");
  console.log(seasonStartDate);
  let prevRankDocs = {};
  if (today !== seasonStartDate) {
    var prevRankDocSnapshot = await dateRankCollectionRef(yesterday).get();
    prevRankDocSnapshot.forEach((doc) => {
      prevRankDocs[doc.data().uid] = doc.data().todayRank;
    });
  }

  // console.log(prevRankDocs);

  async function updateTodayRank(datas, yesterdays) {
    await Promise.all(
      datas.map((data) => {
        if (today === seasonStartDate) {
          data["prevRank"] = null;
          dateRankCollectionRef(today).add(data);
        } else {
          data["prevRank"] =
            yesterdays[data.uid] === null ||
            yesterdays[data.uid] === undefined ||
            yesterdays[data.uid] === null
              ? null
              : yesterdays[data.uid];
          // console.log(yesterdays[data.uid]);
          dateRankCollectionRef(today).add(data);
        }
      })
    );
  }
  // 주석 풀 곳 
  await updateTodayRank(participatedUserSortedCurrentWinPoint, prevRankDocs);




  // console.log(userDocs[0].combo.toString());

  // collection id가 될 날짜 지정

  // rank collection에 넣을 array setting
  // let rankData = [];

  // // userDocs -> rank collection에 넣을 데이터로 만들어서 rankData array에 넣어줌
  // for (var i = 0; i < userDocs.length; i++) {
  //   rankData.push({
  //     uid: userDocs[i].uid,
  //     combo: userDocs[i].combo,
  //     userName: userDocs[i].userName,
  //   });
  // }

  // console.log(rankData);
  // console.log(rankData[0]);

  // // firebase db에 일괄로 밀어 넣는 함수. 가장 빠름.
  // async function testParallelIndividualWrites(datas) {
  //   // collection 전체 일괄 삭제하려면 promise나 batch 사용해야 함
  //   // await rank.doc("season001").collection(today).delete();
  //   await Promise.all(
  //     datas.map((data) => rank.doc("season001").collection(today).add(data))
  //   );
  // }
  // // add는 document id 지정 필요없음
  // // set은 document id 지정 필수

  // testParallelIndividualWrites(rankData);

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

  res.send(participatedUserSortedCurrentWinPoint);
});




exports.lunchtimeScoreVote = functions.region('asia-northeast3').https.onRequest(async (req, res) => {
  const db = admin.firestore();

  // votes -> docu id: date -> voteResult array

  const adminRef = db.collection("admin");
  const votesRef = db.collection("votes");
  const usersRef = db.collection("users");
  const ranksRef = db.collection("ranks");

  const openSeasonSnapshot = await adminRef.doc("openSeason").get();
  const category = openSeasonSnapshot.data().category;

  const season = "lunchEvent";
  const votesSeasonCollection = votesRef.doc(category).collection(season);

  // today -> string으로 변환
  // var today = Date();
  var today = dateFormat(Date(), "yyyymmdd");
  // var today = '20210125';
  console.log(today);
  // const today = "20201005";
  // today의 실제 결과 가져오기 (이전에 넣어야함)

  // var today = "20201214";

  function userVotesSeasonCollection(uid) {
    return usersRef
      .doc(uid)
      .collection("userVote")
      .doc(category)
      .collection(season)
      .doc(today);
  }

  function userVotesSeasonStatsCollection(uid) {
    return usersRef
      .doc(uid)
      .collection("userVote")
      .doc(category)
      .collection(season)
      .doc("stats");
  }

  // const todayRankCollectionRef = ranksRef
  //   .doc(category)
  //   .collection(season)
  //   .doc(today)
  //   .collection(today);

  // const prevRankCollectionRef = ranksRef
  //   .doc(category)
  //   .collection(season)
  //   .doc(yeseterday)
  //   .collection(yeseterday);

  // const dailyVoteSnapshot = votesSeasonCollection.doc(today).get();

  // TODAY RESULT***
  let todayResult = [];
  todayResult = await votesSeasonCollection
    .doc(today)
    .get()
    .then((doc) => doc.data().result); // [1, 2, 2, 1, 2]


    // 임의로 result 넣기
  // let todayResult = [1,1,1,1,1];
  // user의 vote 선택 가져오기
  console.log(todayResult);
  let userCurrentCombo = {};
  let userVotes = {};
  let userScores = {};

  let allUsers = {};
  let allUserUid = [];

  let prevRanks = {};
  let userPrevWinPoint = {};
  var userSnapshot = await usersRef.get();
  userSnapshot.forEach((doc) => {
    allUsers[doc.id] = doc.data();
  });
  // 모든 유저의 uid를 allUsers 리스트에 저장
  userSnapshot.forEach((doc) => {
    allUserUid.push(doc.id);
  });

  // var prevRankSnapshot = await prevRankCollectionRef.get();

  // prevRankSnapshot.forEach((doc) => {
  //   prevRanks[doc.data().uid] = doc.data().todayRank;
  // });
  function compareArray(arr1, arr2) {
 
    // 결과값
    var rst = false;
 
    // 길이가 다르면 다른 배열이라고 판단
    if (arr1.length !== arr2.length) {
        return rst;
    }
 
    // arr1 배열의 크기만큼 반복
    arr1.forEach((item) => {
 
        // arr1 배열 아이템이, arr2 배열에 있는지 확인
        // 있으면, arr2에 item이 존재하는 index 리턴
        // 없으면, -1 리턴
        var i = arr2.indexOf(item);
 
        // 존재하면, splice함수를 이용해서 arr2 배열에서 item 삭제
        if (i > -1) arr2.splice(i, 1);
    });
 
    // compare2의 길이가 0이면 동일하다고 판단.
    rst = arr2.length === 0;
 
    return rst;
}




  // uid 로 각 유저 오늘의 투표 voteSelected 리스트 return
  async function getEachUserVote(datas) {
    await Promise.all(
      datas.map((uid) =>
        userVotesSeasonCollection(uid)
          .get()
          .then((doc) => {

            
            // console.log(data);
            // isVoted가 true인 것만 골라도 됨
            if (
              doc.data() !== undefined &&
              doc.data() !== null &&
              doc.data().voteSelected !== undefined &&
              doc.data().voteSelected !== null &&
              !compareArray(doc.data().voteSelected, [0,0,0,0,0]) 
            ) {
              // console.log(doc.data());
              userVotes[uid] = doc.data().voteSelected;
            }
            return userVotes;
          })
      )
    );
    return userVotes;
  }
  // allUsers 리스트 안의 각 uid를 인자로
  // 각 uservote의 voteSelected를 userVotes에 넣는 함수
await getEachUserVote(allUserUid);
  console.log(userVotes.length);

  // userCurrentCombo array로부터 userVote sub-col의 사용자 선택 가져와서 dictionary로 만들기
  // async function getEachUserVotesAndMakeDict(datas) {
  //   await Promise.all(
  //     datas.map((data) =>
  //       users
  //         .doc(data)
  //         .collection("userVote")
  //         .doc(today)
  //         .get()
  //         .then((doc) => {
  //           userVotes[data] = doc.data().voteSelected;
  //           console.log(userVotes);
  //           return userVotes;
  //         })
  //     )
  //   );
  //   return userVotes;
  // }

  // 사용자 투표 데이터
  // allUserVotesDict = await getEachUserVotesAndMakeDict(
  //   Object.keys(userCurrentCombo)
  // );
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
        } else if (resultArr[i] === 0) {
          score += 1;
        } else {
          score += 0;
        }
      } else {
        score += 0;
      }
      // console.log("%d번 째 문제 현재 점수 %d", i, score);
    }

    return score;
  }

  // userScores Object에 uid:score 로 매핑
  Object.keys(userVotes).forEach((data) => {
    // console.log(data);
    // console.log(userVotes[data]);
    userScores[data] = scoreUserVotes(userVotes[data], todayResult);
  });

  // for (let uid in userVotes) {
  //   score = scoreUserVotes(userVotes[uid], todayResult);
  //   userScores[uid] = score;
  // }
  // testScore = scoreUserVotes([0, 1, 1, 0, 2], [1, 2, 2, 1, 2]);
  // console.log("test Score is " + testScore);

  //{"nOsN2xoEFiPhWiCvyiSuwZXbbSt1":-3,
  // "m2UUvxsAwfdLFP4RB8q4SgkaNgr2":3,
  // "HPyTUH8vU0fFzssMtmttCdTodLA2":3,
  // "JRwNWkUQuBWJ6HDd0xXDbf3XIjp2":-1}

  // user collection에서 각 uid를 찾아 들어가 combo field 업데이트
  async function updateUserScore(datas) {
    await Promise.all(
      Object.keys(datas).map((uid) => {
        // let userScore =  datas[uid];
        // newCombo = userSnapshot.doc(uid).data().combo + datas[uid];
        // console.log(uid);

        console.log(uid + " 's today score will be" + datas[uid]);
        // userVotesSeasonCollection(uid).update({ score: 0 });
        userVotesSeasonCollection(uid).update({ score: datas[uid] });
        return 0;
      })
    );
  }
  // 주석 풀 곳 
  // await updateUserScore(userScores);

  // winPointHistory 넣기 테스트
  // await userVotesSeasonStatsCollection('kakao:1513684681').update({[`winPointHistory.${today}`] : 9});

  async function updateWinPointForTodayVotedUser(datas) {
    await Promise.all(
      Object.keys(datas).map((uid) =>
        userVotesSeasonStatsCollection(uid)
          .get()
          .then((doc) => {

            // console.log(data);
            // const increment = firebase.firestore.FieldValue.increment(userScores[uid]);
            userVotesSeasonStatsCollection(uid).update({
              
              // currentWinPoint:0,
              currentWinPoint:
                ((doc.data() === undefined ||
                doc.data() === null ||
                doc.data().currentWinPoint === null ||
                doc.data().currentWinPoint === undefined)
                  ? 0 + userScores[uid]
                  : doc.data().currentWinPoint + userScores[uid]) < 0
                  ? 0
                  : (doc.data() === undefined ||
                    doc.data() === null ||
                    doc.data().currentWinPoint === null ||
                    doc.data().currentWinPoint === undefined)
                  ? 0 + userScores[uid]
                  : doc.data().currentWinPoint + userScores[uid],
              updatedAt: today,
              // [`winPointHistory.${today}`] : 0,
              [`winPointHistory.${today}`] : userScores[uid],
            });
           
            return 0;
          })
      )
    );
  }

    // 주석 풀 곳 
  // await updateWinPointForTodayVotedUser(userScores);

  // async function updateCurrentWinPointAtUserVoteStats(
  //   userPrevWinPoint,
  //   userScores,
  //   allUsers
  // ) {
  //   await Promise.all(
  //     Object.keys(userScores).map((uid) => {
  //       var prevWinPoint =
  //         userPrevWinPoint[uid] === null || userPrevWinPoint[uid] === undefined
  //           ? 0
  //           : userPrevWinPoint[uid];

  //       var updatedWinPoint =
  //         userPrevWinPoint[uid] === null || userPrevWinPoint[uid] === undefined
  //           ? 0 + userScores[uid]
  //           : userPrevWinPoint[uid] + userScores[uid];
  //       if (updatedWinPoint < 0) {
  //         updatedWinPoint = 0;
  //       }
  //       //user stat에 currentWinPoint에 업데이트
  //       userVotesSeasonStatsCollection(uid).update({
  //         currentWinPoint: updatedWinPoint,
  //         updatedAt: today,
  //       });

  //       return 0;
  //     })
  //   );
  // }

  // await updateCurrentWinPointAtUserVoteStats(
  //   userPrevWinPoint,
  //   userScores,
  //   allUsers
  // );

  res.send(userScores);
});

// exports.tempQuries = functions.https.onRequest(async (req, res) => {
//   const db = admin.firestore();

//   // votes -> docu id: date -> voteResult array

//   const adminRef = db.collection("admin");
//   const votesRef = db.collection("votes");
//   const usersRef = db.collection("users");
//   const ranksRef = db.collection("ranks");

//   const openSeasonSnapshot = await adminRef.doc("openSeason").get();
//   const category = openSeasonSnapshot.data().category;

//   const season = openSeasonSnapshot.data().season;
//   const votesSeasonCollection = votesRef.doc(category).collection(season);

//   // today -> string으로 변환
//   // var today = Date();
//   var date = dateFormat(today, "yyyymmdd");

//   console.log(date);
//   // const today = "20201005";
//   // today의 실제 결과 가져오기 (이전에 넣어야함)

//   var today = "20201020";

//   function userVotesSeasonCollection(uid) {
//     return usersRef
//       .doc(uid)
//       .collection("userVote")
//       .doc(category)
//       .collection(season)
//       .doc(today);
//   }

//   function userVotesSeasonStatsCollection(uid) {
//     return usersRef
//       .doc(uid)
//       .collection("userVote")
//       .doc(category)
//       .collection(season)
//       .doc("stats");
//   }

//   const todayRankCollectionRef = ranksRef
//     .doc(category)
//     .collection(season)
//     .doc(today)
//     .collection(today);

//   // const prevRankCollectionRef = ranksRef
//   //   .doc(category)
//   //   .collection(season)
//   //   .doc(yeseterday)
//   //   .collection(yeseterday);

//   // const dailyVoteSnapshot = votesSeasonCollection.doc(today).get();
//   let todayResult = [];
//   todayResult = await votesSeasonCollection
//     .doc(today)
//     .get()
//     .then((doc) => doc.data().result); // [1, 2, 2, 1, 2]

//   // user의 vote 선택 가져오기
//   console.log(todayResult);
//   let userCurrentCombo = {};
//   let userVotes = {};
//   let userScores = {};

//   let allUsers = {};
//   let allUserUid = [];

//   let prevRanks = {};
//   let userPrevWinPoint = {};
//   var userSnapshot = await usersRef.get();
  
//   userSnapshot.forEach((doc) => {
//     allUsers[doc.id] = doc.data();
//   });
//   // 모든 유저의 uid를 allUsers 리스트에 저장
//   userSnapshot.forEach((doc) => {
//     allUserUid.push(doc.id);
//   });

//   // var prevRankSnapshot = await prevRankCollectionRef.get();

//   // prevRankSnapshot.forEach((doc) => {
//   //   prevRanks[doc.data().uid] = doc.data().todayRank;
//   // });

//   // item 15개 추가
//   async function getEachUserVote(datas) {
//     await Promise.all(
//       datas.map((uid) =>
//         usersRef.doc(uid).update({ item: admin.firestore.FieldValue.increment(15) })
        
//       )
//     );
//     return 0;
//   }
//   // allUsers 리스트 안의 각 uid를 인자로
//   // 각 uservote의 voteSelected를 userVotes에 넣는 함수
//   await getEachUserVote(allUserUid); 
 

//   res.send(userScores);
// });


exports.verifyKakaoToken = functions.region('asia-northeast3').https.onCall(async (data, context) => {
  const token = data.token;

  // const token="ISLIonA68NEOVlp4EUadn-21bnEXcyYgtxHHdQo9dVoAAAF1ayJlvQ"
  if (!token) return { error: "There is no token provided." };

  console.log(`Verifying Kakao token: ${token}`);

  

  return kakao
    .createFirebaseToken(token)
    .then(firebaseToken => {
      console.log(`Returning firebase token to user: ${firebaseToken}`);
      // res.send(firebaseToken);
      return { token: firebaseToken };
    })
    .catch(e => {
      return { error: e.message };
    });
});

exports.sendFCM2 = functions.region('asia-northeast3').https.onCall((data, context) => {
  // var token = data["token"];
  var mytopic = 'timeTopic';

  // var title = data["title"];
  // var body = data["body"];
  // var token = 'vsbnEgDWk25uwL9OzLUaG:APA91bGcjJ89HcBg0CNmiJF3n0fiaREJgjPrYpRKZ0dYaPD4yWex9GioJdJqXeTJ6yeei5IEFvV9sLnsc7wZLbRGI_Kt6NAPoV6LfLx4mppnp3WEWpLmeSRk7mtD28OKlvmM2bApTPva';
  // var title = 'testAlert';
  // var body = 'testBody';

  var mypayload = {
    // from: '/topics/timeTopic',
    collapse_key: 'com.team-yacht.ggook',
    notification: {
      // title: title,
      body: 'testBody'
    }
  }

  // var result = admin.messaging().sendToDevice(token, payload);
  var result = admin.messaging().sendToTopic(mytopic, mypayload);
  return result;
})



//fcm 알림부분. starte dat 2021.12.18
exports.newOneOnOne = functions.region('asia-northeast3').firestore.document('/admin/userOneOnOne/userOneOnOne/{docId}').onWrite(async (change, context) => {
  // change includes changed data in firestore (before -> after)
  // console.log('change: ', change );
  // context includes params
  // console.log('context: ', context );
  // const sender = context.params.docId;
  // get the changed data
  const data = change.after.data();
  console.log('message : ', data);

  const payload = {
    notification: {
      title: '1:1 문의 발생 from ' + data['userName'],
      body: data['content']
    }
  };

  //kakao:1513684681  7번방의선물옵션
  //kakao:1518231402  칼레오스콥
  //kakao:1518411965  여수밤빠다
  //kakao:1531290810  테스형

  // const getAdminPushTokensPromise = admin.database()
  // .ref(`/users/${followedUid}/notificationTokens`).once('value');

  const db = admin.firestore();
  const usersRef = db.collection("users");
  const adminPushTokenSnapshot = await usersRef.doc("kakao:1518231402").get();
  const adminPushToken = adminPushTokenSnapshot.data().token;

  const adminPushTokens = [adminPushToken, adminPushToken];

  console.log(adminPushTokens[0], adminPushTokens[1])

  // pushTokens = ['fEpRNr9_jEc-h3-eTWbmun:APA91bFP-yhn8bM1098PWPDqopFDxW3bNvF-V-HDcho9_ReXQMZ2FcTS53RbMT59CCbfK8iSFwUPP2WmTsUu2vnVsHCuEcYwwllxMzN5a4FfGvyDIQsaNYr_K4JkXSK_m5k4AHjCcn1H'];

  // console.log('sending message..', pushToken, payload);

  const response = await admin.messaging().sendToDevice(adminPushTokens, payload);

  response.results.forEach(
    (result, index) => {
      const error = result.error;
      if(error) {
        console.log('Failure sending notification');
      }
    }
  );

  console.log(response);
  // get users collection
  // const users = admin.firestore().collection('users');
  // build push notification
  // const payload = {
  //   notification: {
  //   title: 'title',
  //   body: data.message
  //   }
  // };

  // await users.get()
  // .then(snapshot => {
  //   snapshot.forEach(doc => {
  //     console.log('doc.id', doc.id);
  //     console.log('sender', sender);
  //     console.log('doc', doc);
  //     // do not send notification to the sender
  //     if (doc.id !== sender) {
  //       // get the push token of a user
  //       pushToken = doc.data().pushToken;
  //       console.log('token, sending message', pushToken, payload);
  //       // send notification trhough firebase cloud messaging (fcm)
  //       admin.messaging().sendToDevice(pushToken, payload);
  //     } else {
  //       console.log( 'the sender is the same', doc.id, sender);
  //     }
  //   });
  //   return 'sent message to all users';
  // })
  // .catch(err => {
  //   console.log('Error getting documents', err);
  // });
});

exports.newCommentsTest5 = functions.region('asia-northeast3').firestore.document('/posts/{docId1}/comments/{docId2}').onCreate(async (snapshot, context) => {
  const data = snapshot.data();

  const postId = context.params.docId1; // 원글의 uid
  const commentId = context.params.docId2; // 댓글의 uid

  const db = admin.firestore();
  const postsRef = db.collection('posts');
  const usersRef = db.collection('users');

  const writerUidSnapshot = await postsRef.doc(postId).get();
  const writerUid = writerUidSnapshot.data().writerUid;

  const fcmTokenSnapshot = await usersRef.doc(writerUid).get();
  const fcmToken = fcmTokenSnapshot.data().token;
  
  console.log('postId : ', postId);
  console.log('commentId : ', commentId);
  console.log('writerUid : ', writerUid);
  console.log('fcmToken of writer : ', fcmToken);

  const payload = {
    notification: {
      title: data['writerUserName'] + '님이 답글을 달았어요!',
      body: data['content'],
    },
  };

  const response = await admin.messaging().sendToDevice('e7HK0LmhrER1lIYlsJeCak:APA91bEtYj2TN1VFzB0NS1Flckl0UKU_tJ1bL9I11DZo-5aByv_Ldu1cOa_Pxdkf9lIY-o-ePvg8xlHNuDDASIaHTddNNm5LGg5AiF_qlrXA8HdIjZvwp4gEET5agMOhCA6fTywymm2X', payload);

  console.log(response);
});

exports.newPost = functions.region('asia-northeast3').firestore.document('/posts/{docId}').onCreate(async (snapshot, context) =>{
  const data = snapshot.data();
  const postId = context.params.docId;
  const tel_token = '1559530541:AAEWKpjUTT-ICPx32oxvSjgH8qUQhT5G-z4';

  const bot = new Telegraf(tel_token);
  
  // console.log(data['writerUserName']);
  bot.launch();
  const chat_id = '71048145';
  bot.telegram.sendMessage(chat_id, data['writerUserName'] + '님의 글: ' + data['content']);
})

exports.newUserRequest = functions.region('asia-northeast3').firestore.document('/admin/userOneOnOne/{date}/{doc}').onCreate(async (snapshot, context) =>{
  const data = snapshot.data();
  const tel_token = '5066842147:AAHNEtMSQxPWyXo8kxX5Bky5E9Dixc6vKNA';
  const db = admin.firestore();
  const usersRef = db.collection('users');
  const bot = new Telegraf(tel_token);
  const jk = '71048145';
  const kyutae = '266861929';
  const long = '191245328';
  const csejun = '359260852';
  const userName = await usersRef.doc(data['uid']).get().then((doc)=>doc.data().userName);
  

  const youngjas = [jk, kyutae, long, csejun];
  
  bot.launch();
  youngjas.forEach((chat_id) => {
    bot.telegram.sendMessage(chat_id,userName +'('+ data['uid']+')' + ' 님의 문의: ' + data['content']);
  });
})

exports.manageUserRequest = functions.region('asia-northeast3').https.onRequest(async (req, res) => {
  const tel_token = '1559530541:AAEWKpjUTT-ICPx32oxvSjgH8qUQhT5G-z4';
  const jk = '71048145';
  // bot.launch();
  bot.command('/show', (ctx) => {    
  ctx.reply('Hello! 무엇을 보여드릴까요?');})
  return await bot.handleUpdate(request.body, response).then((rv) => {
    // if it's not a request from the telegram, rv will be undefined, but we should respond with 200
    return !rv && response.sendStatus(200)
  })


})