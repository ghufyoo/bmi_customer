importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCiy3IU8-Enn3zf8p7crwlzmRcXb5BPurQ",
  authDomain: "bmiorder-db8c9.firebaseapp.com",
  projectId: "bmiorder-db8c9",
  storageBucket: "bmiorder-db8c9.appspot.com",
  messagingSenderId: "303209621681",
  appId: "1:303209621681:web:257dee6b310eaa33bd9a90",
  measurementId: "G-BC54VEVHW8"
});

const messaging = firebase.messaging();

// Optional:
if (firebase.messaging.isSupported()) {
  const messaging = !firebase.apps.length
    ? firebase.initializeApp(firebaseConfig).messaging()
    : firebase.app().messaging();
}
// messaging.onBackgroundMessage(function (payload) {
//   console.log('Received background message ', payload);

//   const notificationTitle = payload.notification.title;
//   const notificationOptions = {
//     body: payload.notification.body,
//     icon: 'icons/icon-192.png',
//     badge: 'icons/badge.png'
//   };

//   self.registration.showNotification(notificationTitle,
//     notificationOptions);
// });