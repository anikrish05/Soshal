// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyAWwQQQ-Wj3Tb-7huiw8CdoI9krTsNF4UA",
  authDomain: "gdsc-7069b.firebaseapp.com",
  projectId: "gdsc-7069b",
  storageBucket: "gdsc-7069b.appspot.com",
  messagingSenderId: "207257008294",
  appId: "1:207257008294:web:8c151991199f12ed77dc67",
  measurementId: "G-T62TCR1X7P"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);