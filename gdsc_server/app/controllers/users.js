const { db, auth } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");

console.log("in controller")
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
    myEvents: []
  }
  if(isOwner == "true"){
    data.role = "owner"
    data.clubsOwned = []
  }
  else{
    data.owner = "user"
  }
  console.log(data)
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
  console.log("login")
     const {email, password} = req.body;
  signInWithEmailAndPassword(auth, email, password).then((userCredential) => {
  // Signed in
  var user = userCredential.user;
  console.log(user);
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

module.exports = {
  signup,
  login,
  signedIn,
  signout,
  userData
};