const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { user } = require("firebase-functions/lib/providers/auth");
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

var dateFormat = require("dateformat");
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

  const adminRef = db.collection("admin");
  const votesRef = db.collection("votes");
  const usersRef = db.collection("users");
  const ranksRef = db.collection("ranks");

  const openSeasonSnapshot = await adminRef.doc("openSeason").get();
  const category = openSeasonSnapshot.data().category;

  const season = openSeasonSnapshot.data().season;
  const votesSeasonCollection = votesRef.doc(category).collection(season);

  // today -> string으로 변환
  // var today = Date();
  var date = dateFormat(today, "yyyymmdd");

  console.log(date);
  // const today = "20201005";
  // today의 실제 결과 가져오기 (이전에 넣어야함)

  var today = "20201019";

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

  const todayRankCollectionRef = ranksRef
    .doc(category)
    .collection(season)
    .doc(today)
    .collection(today);

  // const prevRankCollectionRef = ranksRef
  //   .doc(category)
  //   .collection(season)
  //   .doc(yeseterday)
  //   .collection(yeseterday);

  // const dailyVoteSnapshot = votesSeasonCollection.doc(today).get();
  let todayResult = [];
  todayResult = await votesSeasonCollection
    .doc(today)
    .get()
    .then((doc) => doc.data().result); // [1, 2, 2, 1, 2]

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
              doc.data().voteSelected !== null &&
              doc.data().voteSelected !== undefined
            ) {
              console.log(doc.data());
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
      console.log("%d번 째 문제 현재 점수 %d", i, score);
    }

    return score;
  }

  // userScores Object에 uid:score 로 매핑
  Object.keys(userVotes).forEach((data) => {
    console.log(data);
    console.log(userVotes[data]);
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

        userVotesSeasonCollection(uid).update({ score: datas[uid] });
        return 0;
      })
    );
  }

  await updateUserScore(userScores);

  async function updateWinPointForTodayVotedUser(datas) {
    await Promise.all(
      Object.keys(datas).map((uid) =>
        userVotesSeasonStatsCollection(uid)
          .get()
          .then((doc) => {
            // console.log(data);

            userVotesSeasonStatsCollection(uid).update({
              currentWinPoint:
                (doc.data() === undefined ||
                doc.data() === null ||
                doc.data().currentWinPoint === null ||
                doc.data().currentWinPoint === undefined
                  ? 0 + userScores[uid]
                  : doc.data().currentWinPoint + userScores[uid]) < 0
                  ? 0
                  : doc.data() === undefined ||
                    doc.data() === null ||
                    doc.data().currentWinPoint === null ||
                    doc.data().currentWinPoint === undefined
                  ? 0 + userScores[uid]
                  : doc.data().currentWinPoint + userScores[uid],
              updatedAt: today,
            });

            return 0;
          })
      )
    );
  }

  await updateWinPointForTodayVotedUser(userScores);

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
exports.sortRank = functions.https.onRequest(async (req, res) => {
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

  const today = "20201019";
  const yesterday = "20201016";
  // todayRankRef

  const seasonInfoRef = votesRef
    .doc(category)
    .collection(season)
    .doc("seasonInfo");

  const seasonStartDate = await seasonInfoRef
    .get()
    .then((doc) => doc.data().startDate);

  function dateRankCollectionRef(date) {
    return ranksRef.doc(category).collection(season).doc(date).collection(date);
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
            if (
              statsData.data().currentWinPoint !== null &&
              statsData.data().currentWinPoint !== undefined
            ) {
              console.log(statsData.data());

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
  console.log(participatedUserSortedCurrentWinPoint.length);
  console.log(participatedUserSortedCurrentWinPoint);

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

  console.log(participatedUserSortedCurrentWinPoint.length);
  console.log(participatedUserSortedCurrentWinPoint);
  console.log("seasonStart at");
  console.log(seasonStartDate);
  let prevRankDocs = {};
  if (today !== seasonStartDate) {
    var prevRankDocSnapshot = await dateRankCollectionRef(yesterday).get();
    prevRankDocSnapshot.forEach((doc) => {
      prevRankDocs[doc.data().uid] = doc.data().todayRank;
    });
  }

  console.log(prevRankDocs);

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
          console.log(data);
          dateRankCollectionRef(today).add(data);
        }
      })
    );
  }

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
