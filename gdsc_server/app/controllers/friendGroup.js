const { db, auth } = require('../../db/config');
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc, updateDoc } = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut } = require("firebase/auth");
const { uploadString, getDownloadURL, getStorage  } = require("firebase/storage");
const { checkAuthorization } = require('./authorizationUtil');


module.exports = {

};
