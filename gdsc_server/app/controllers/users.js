const { db, auth, storage } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
const { ref, uploadBytes } = require('firebase/storage');
const {  getDownloadURL, uploadBytesResumable} = require("firebase/storage");
const multer = require('multer');
const upload = multer(); // Initialize multer
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



const updateProfileImage = async (req, res) => {
  try {
    console.log('Received image upload request:', req.body);

    const now = new Date();
    const timeStamp = now.getTime();
    const { img, uid } = req.body;
    console.log("wasgup");

    // Use multer middleware to parse form data
    upload.none()(req, res, async (err) => {
      if (err) {
        console.error(err);
        return res.status(500).send({ message: 'Error processing form data' });
      }

      const storageRef = ref(storage, `users/${uid}/${img.originalname + timeStamp}`);
      const metadata = {
        contentType: img.mimetype,
      };

      const snapshot = await uploadBytes(storageRef, img.buffer, metadata);
      const downloadURL = await getDownloadURL(snapshot.ref);

      await updateDoc(doc(db, "users", uid), { "downloadURL": downloadURL });
      res.status(200).send(JSON.stringify({ message: "Profile Pic Updated" }));
    });
  } catch (error) {
    res.status(500).send(JSON.stringify({ message: error.message }));
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
   auth.signOut().then(()=>{
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
  userData,
  updateProfileImage
};