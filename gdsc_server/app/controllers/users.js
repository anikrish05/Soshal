const { db, auth, storage } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
const { ref, uploadBytes } = require('firebase/storage');

const signup  = async (req, res) => {
  const {email, password, name, isOwner} = req.body;
  createUserWithEmailAndPassword(auth, email, password).then((userCredential) => {
  var user = userCredential.user;
  const data = {
    uid: user.uid,
    downloadURL: "",
    following: [],
    displayName: name,
    role: "",
    email: email,
    myEvents: [],
    clubsOwned: []

  }
  if(isOwner == "true"){
    data.role = "owner"
  }
  else{
    data.role = "user"
  }
  setDoc(doc(db, "users", data.uid), data).then(()=>{
       res.status(200).send(JSON.stringify({ message: user}))

     })

    }).catch((error) => {
        var errorCode = error.code;
        var errorMessage = error.message;
        res.status(500).send(JSON.stringify({ message: error}))
    });
}
const login  = async (req, res) => {
     const {email, password} = req.body;
  signInWithEmailAndPassword(auth, email, password).then((userCredential) => {
  // Signed in
  var user = userCredential.user;
   res.status(200).send(JSON.stringify({ message: user}))
    }).catch((error) => {
        var errorCode = error.code;
        var errorMessage = error.message;
        res.status(500).send({
          error: {
            status: errorCode || 500,
            message: errorMessage || 'Internal Server Error',
          },
    });
    });
}

const signedIn  = async (req, res) => {
  auth.onAuthStateChanged(function(user) {
    if (user) {
      res.send(JSON.stringify({message: user}))
    } else {
      res.send(JSON.stringify({message: false}))
    }
  });
} 

const signout  = async (req, res) => {
   auth.signOut.then(()=>{
    res.status(200).send(JSON.stringify({ message: "Signed Out"}))
  }).catch((error) => {
    res.status(500).send(JSON.stringify({ message: error}))
  });
}

const userData  = async (req, res) => {
  auth.onAuthStateChanged(function(user) {
    if (user) {
       getDoc(doc(db, "users", user.uid)).then((data)=>{
        res.status(200).send(JSON.stringify({'message':data.data()}))
    })
  } 
  });
}

const rsvp = async(req, res) => {
  const { uid, eventID } = req.body;
  const userDoc = doc(db, "users", uid);
    const userData = (await getDoc(userDoc)).data();
    const updatedRSVP = userData.myEvents ? [...userData.myEvents, eventID] : [eventID];
    await setDoc(userDoc, { myEvents: updatedRSVP }, { merge: true });
}

const deRSVP = async (req, res) => {
  const { uid, eventID } = req.body;
  const userDoc = doc(db, "users", uid);
    const userData = (await getDoc(userDoc)).data();
    const updatedRSVP = userData.myEvents ? userData.myEvents.filter(item => item !== eventID) : [];
    await setDoc(userDoc, { myEvents: updatedRSVP }, { merge: true });
}

const updateProfile = async(req, res) => {
  const {displayName, classOf, uid} = req.body;
  const userDoc = doc(db, "users", uid);
    const userData = (await getDoc(userDoc)).data();
    await setDoc(userDoc, { displayName: displayName, classOf: classOf }, { merge: true });
}

module.exports = {
  signup,
  login,
  signedIn,
  signout,
  userData,
  rsvp,
  deRSVP,
  updateProfile
};