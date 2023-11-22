const express = require('express')
const app = express()
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
const { initializeApp } = require('firebase/app');
const { getFirestore, collection, getDocs, doc, setDoc, getDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");


const port = 3000
  var config = {
    apiKey: "AIzaSyAWwQQQ-Wj3Tb-7huiw8CdoI9krTsNF4UA",
    authDomain: "gdsc-7069b.firebaseapp.com",
    projectId: "gdsc-7069b",
    storageBucket: "gdsc-7069b.appspot.com",
    messagingSenderId: "207257008294",
    appId: "1:207257008294:web:8c151991199f12ed77dc67",
    measurementId: "G-T62TCR1X7P"
  };
const FirebaseApp = initializeApp(config);
const db = getFirestore(FirebaseApp);
const auth = getAuth(FirebaseApp);

app.get('/', async (req, res) => {
  const data = {
  name: 'Los Angeles',
  state: 'CA',
  country: 'USA'
};
  await setDoc(doc(db, "clubs", "new-city-id"), data);
  res.send(JSON.stringify({ message: "Helljo World"}))
})
app.post('/signup', (req, res) =>{
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
})

app.post('/login', (req, res) =>{
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
})

app.get('/signedIn', (req, res) =>{
  auth.onAuthStateChanged(function(user) {
  if (user) {
    res.send(JSON.stringify({message: user}))
  } else {
    res.send(JSON.stringify({message: false}))
  }
  });
})

app.get('signOut', (req, res) =>{
  auth.signOut.then(()=>{
    res.status(200).send(JSON.stringify({ message: "Signed Out"}))
  }).catch((error) => {
  res.status(500).send(JSON.stringify({ message: error}))

});

})

app.get('userData', async (req, res) => {
  auth.onAuthStateChanged(function(user) {
  if (user) {
     getDoc(doc(db, "users", user.uid)).then((data)=>{
      res.status(200).send(JSON.stringify({'message':data.data()}))
    })
  } 
  });
})

app.listen(port, () => {
  console.log(`Soshal listening on port ${port}`)
})
