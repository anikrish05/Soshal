const { initializeApp } = require('firebase/app');
const { getFirestore, collection, getDocs, doc, setDoc, getDoc } = require('firebase/firestore');
const { getStorage } = require('firebase/storage');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut } = require("firebase/auth");
const admin = require('firebase-admin');

const port = 3000;
const config = {
  apiKey: "AIzaSyAWwQQQ-Wj3Tb-7huiw8CdoI9krTsNF4UA",
  authDomain: "gdsc-7069b.firebaseapp.com",
  projectId: "gdsc-7069b",
  storageBucket: "gdsc-7069b.appspot.com",
  messagingSenderId: "207257008294",
  appId: "1:207257008294:web:8c151991199f12ed77dc67",
  measurementId: "G-T62TCR1X7P",
  storageBucket: "gs://gdsc-7069b.appspot.com"
};

const FirebaseApp = initializeApp(config);
const db = getFirestore(FirebaseApp);
const auth = getAuth(FirebaseApp);
const storage = getStorage(FirebaseApp);

// Initialize Firebase Admin SDK
const serviceAccount = require('./serviceAccountKey.json'); // Assuming it's in the same directory
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://gdsc-7069b.firebaseio.com', // Use your database URL
});

module.exports = {
  db,
  auth,
  storage,
  admin
};
