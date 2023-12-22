const { db, auth, storage } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
const { ref, uploadBytes } = require('firebase/storage');

const signup = async (req, res) => {
  try {
    const { email, password, name, classOf } = req.body;
    const userCredential = await createUserWithEmailAndPassword(auth, email, password);
    const user = userCredential.user;

    const data = {
      uid: user.uid,
      downloadURL: "",
      following: [],
      displayName: name,
      role: false,
      email: email,
      myEvents: [],
      clubsOwned: [],
      classOf: classOf
    };

    await setDoc(doc(db, "users", data.uid), data);

    res.status(200).send(JSON.stringify({ message: 'User created successfully' }));
  } catch (error) {
    const errorCode = error.code;
    const errorMessage = error.message;
    res.status(500).send(JSON.stringify({ error: { code: errorCode, message: errorMessage } }));
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    const user = userCredential.user;

    res.status(200).send(JSON.stringify({ message: 'Login successful', user }));
  } catch (error) {
    const errorCode = error.code;
    const errorMessage = error.message;
    res.status(500).send({
      error: {
        status: errorCode || 500,
        message: errorMessage || 'Internal Server Error',
      },
    });
  }
};


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
    res.status(200).send(JSON.stringify({'message':"success"}))

}

const deRSVP = async (req, res) => {
  const { uid, eventID } = req.body;
  const userDoc = doc(db, "users", uid);
    const userData = (await getDoc(userDoc)).data();
    const updatedRSVP = userData.myEvents ? userData.myEvents.filter(item => item !== eventID) : [];
    await setDoc(userDoc, { myEvents: updatedRSVP }, { merge: true });
    res.status(200).send(JSON.stringify({'message':"success"}))

}

const updateProfile = async(req, res) => {
  const {displayName, classOf, uid} = req.body;
  const userDoc = doc(db, "users", uid);
    const userData = (await getDoc(userDoc)).data();
    await setDoc(userDoc, { displayName: displayName, classOf: classOf }, { merge: true });
   res.status(200).send(JSON.stringify({'message':"success"}))

}

const getAllUsers = async (req, res) => {
  try {
    let users = [];
    const userRef = collection(db, "users");
    const userData = await getDocs(userRef);

    users = userData.docs.map(doc => doc.data());

    res.status(200).send(JSON.stringify({ "message": users }));
  } catch (error) {
    console.error("Error getting document:", error);
    res.status(500).send(JSON.stringify({ message: "Failed", error: error.message }));
  }
};


module.exports = {
  signup,
  login,
  signedIn,
  signout,
  userData,
  rsvp,
  deRSVP,
  updateProfile,
  getAllUsers
};