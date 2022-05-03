// //import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-app.js";
// // import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-analytics.js";
// // import { getFirestore } from "firebase/firestore";
// // import { getStorage } from "firebase/storage";
// // import { getAuth, createUserWithEmailAndPassword } from "firebase/auth";
//  importScripts("https://www.gstatic.com/firebasejs/9.6.01/firebase-app.js");
//  importScripts("https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging.js");

// // // https://firebase.google.com/docs/web/setup#available-libraries
// // // importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-a6p.js');
// // //import { getMessaging, getToken } from "firebase/messaging";
// // // Your web app's Firebase configuration
// // // For Firebase JS SDK v7.20.0 and later, measurementId is optional
// firebase.initializeApp({
//     apiKey: "AIzaSyCiy3IU8-Enn3zf8p7crwlzmRcXb5BPurQ",
//     authDomain: "bmiorder-db8c9.firebaseapp.com",
//     projectId: "bmiorder-db8c9",
//     storageBucket: "bmiorder-db8c9.appspot.com",
//     messagingSenderId: "303209621681",
//     appId: "1:303209621681:web:257dee6b310eaa33bd9a90",
//     measurementId: "G-BC54VEVHW8"
// });

// // // Initialize Firebase
// const app = initializeApp(firebaseConfig);
// const messaging = firebase.messaging();
// messaging.setBackgroundMessageHandler(function (payload) {
//     const promiseChain = clients
//         .matchAll({
//             type: "window",
//             includeUncontrolled: true
//         })
//         .then(windowClients => {
//             for (let i = 0; i < windowClients.length; i++) {
//                 const windowClient = windowClients[i];
//                 windowClient.postMessage(payload);
//             }
//         })
//         .then(() => {
//             return registration.showNotification("New Message");
//         });
//     return promiseChain;
// });
// self.addEventListener('notificationclick', function (event) {
//     console.log('notification received: ', event)
// });


// getToken(messaging, { vapidKey: 'BFIQRP4_twQWdebyljX-7yWrApT65YxohCu7B6I2oN_3WCRiTvy-fnZ-CH1Z6mOF0rtC7uNY12eSMpZ86SWf6oU' }).then((currentToken) => {
//     if (currentToken) {
//         // Send the token to your server and update the UI if necessary
//         // ...
//     } else {
//         // Show permission request UI
//         console.log('No registration token available. Request permission to generate one.');
//         // ...
//     }
// }).catch((err) => {
//     console.log('An error occurred while retrieving token. ', err);
//     // ...
// });
console.log('yo');

// onmessage(messaging, (payload) => {
//     console.log('Message received', payload);
// });