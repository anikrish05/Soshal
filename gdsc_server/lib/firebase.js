import { initializeApp, getApps } from "firebase/app";
import { getFirestore, collection, getDocs } from 'firebase/firestore/lite';



  const firebaseConfig = {
    apiKey: "AIzaSyAWwQQQ-Wj3Tb-7huiw8CdoI9krTsNF4UA",
    authDomain: "gdsc-7069b.firebaseapp.com",
    projectId: "gdsc-7069b",
    storageBucket: "gdsc-7069b.appspot.com",
    messagingSenderId: "207257008294",
    appId: "1:207257008294:web:8c151991199f12ed77dc67",
    measurementId: "G-T62TCR1X7P"
  };


const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export default app;
