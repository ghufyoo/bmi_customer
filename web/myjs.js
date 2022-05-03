

firebase.initializeApp({
    apiKey: "AIzaSyCiy3IU8-Enn3zf8p7crwlzmRcXb5BPurQ",
    authDomain: "bmiorder-db8c9.firebaseapp.com",
    projectId: "bmiorder-db8c9",
    storageBucket: "bmiorder-db8c9.appspot.com",
    messagingSenderId: "303209621681",
    appId: "1:303209621681:web:257dee6b310eaa33bd9a90",
    measurementId: "G-BC54VEVHW8"
});

// Initialize Firebase

const app = initializeApp(firebaseConfig);
const messaging = getMessaging();
// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// admin.initializeApp()

// exports.sendNotification = functions.firestore
//   .document('messages/{groupId1}/{groupId2}/{message}')
//   .onCreate((snap, context) => {
//     console.log('----------------start function--------------------')

//     const doc = snap.data()
//     console.log(doc)

//     const idFrom = doc.idFrom
//     const idTo = doc.idTo
//     const contentMessage = doc.content

//     // Get push token user to (receive)
//     admin
//       .firestore()
//       .collection('users')
//       .where('id', '==', idTo)
//       .get()
//       .then(querySnapshot => {
//         querySnapshot.forEach(userTo => {
//           console.log(`Found user to: ${userTo.data().nickname}`)
//           if (userTo.data().pushToken && userTo.data().chattingWith !== idFrom) {
//             // Get info user from (sent)
//             admin
//               .firestore()
//               .collection('users')
//               .where('id', '==', idFrom)
//               .get()
//               .then(querySnapshot2 => {
//                 querySnapshot2.forEach(userFrom => {
//                   console.log(`Found user from: ${userFrom.data().nickname}`)
//                   const payload = {
//                     notification: {
//                       title: `You have a message from "${userFrom.data().nickname}"`,
//                       body: contentMessage,
//                       badge: '1',
//                       sound: 'default'
//                     }
//                   }
//                   // Let push to the target device
//                   admin
//                     .messaging()
//                     .sendToDevice(userTo.data().pushToken, payload)
//                     .then(response => {
//                       console.log('Successfully sent message:', response)
//                     })
//                     .catch(error => {
//                       console.log('Error sending message:', error)
//                     })
//                 })
//               })
//           } else {
//             console.log('Can not find pushToken target user')
//           }
//         })
//       })
//     return null
//   })