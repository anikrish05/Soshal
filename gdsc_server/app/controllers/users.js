const { db, auth, storage } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
const { uploadString, getDownloadURL, getStorage  } = require("firebase/storage");

const { ref, uploadBytes } = require('firebase/storage');
const { Buffer } = require('buffer');
const multer = require('multer');
const multerStorage = multer.memoryStorage();
const multerUpload = multer({ storage: multerStorage });

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

const getUser = async (req, res) => {
    try {
        const id = req.params.id;
        const userDoc = await getDoc(doc(db, "users", id));

        if (userDoc.exists()) {
            res.status(200).send(JSON.stringify({ "message": userDoc.data() }));
        } else {
            res.status(404).send(JSON.stringify({ "message": "User not found" }));
        }
    } catch (error) {
        console.error("Error getting user document:", error);
        res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
    }
}

const followPublicClub = async (req, res) => {
  try {
    const { clubId, uid } = req.body;

    // Update user's following field
    const userDocRef = doc(db, "users", uid);
    const userDoc = await getDoc(userDocRef);
    const userData = userDoc.data();
    
    // Assuming userData.following is a map
    userData.following[clubId] = "Accepted";

    await setDoc(userDocRef, { following: userData.following }, { merge: true });

    // Update club's followers field
    const clubDocRef = doc(db, "clubs", clubId);
    const clubDoc = await getDoc(clubDocRef);
    const clubData = clubDoc.data();
    
    // Assuming clubData.followers is a map
    clubData.followers[uid] = "Accepted";

    await setDoc(clubDocRef, { followers: clubData.followers }, { merge: true });

    res.status(200).send(JSON.stringify({ "message": "Success" }));
  } catch (error) {
    console.error("Error following public club:", error);
    res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
  }
}

const followPrivateClub = async (req, res) => {
  try {
    const { clubId, uid } = req.body;

    // Update user's following field
    const userDocRef = doc(db, "users", uid);
    const userDoc = await getDoc(userDocRef);
    const userData = userDoc.data();
    
    // Assuming userData.following is a map
    userData.following[clubId] = "Requested";

    await setDoc(userDocRef, { following: userData.following }, { merge: true });

    // Update club's followers field
    const clubDocRef = doc(db, "clubs", clubId);
    const clubDoc = await getDoc(clubDocRef);
    const clubData = clubDoc.data();
    
    // Assuming clubData.followers is a map
    clubData.followers[uid] = "Requested";

    await setDoc(clubDocRef, { followers: clubData.followers }, { merge: true });

    res.status(200).send(JSON.stringify({ "message": "Success" }));
  } catch (error) {
    console.error("Error following public club:", error);
    res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
  }
}

const unfollowClub = async (req, res) => {
  console.log("INGGG");
  try {
    const { clubId, uid } = req.body;

    // Remove user from club's followers
    const clubDocRef = doc(db, "clubs", clubId);
    const clubDoc = await getDoc(clubDocRef);
    const clubData = clubDoc.data();

    // Assuming clubData.followers is a map
    delete clubData.followers[uid];

    await setDoc(clubDocRef, { followers: clubData.followers }, { merge: true });

    // Remove club from user's following
    const userDocRef = doc(db, "users", uid);
    const userDoc = await getDoc(userDocRef);
    const userData = userDoc.data();

    // Assuming userData.following is a map
    delete userData.following[clubId];

    await setDoc(userDocRef, { following: userData.following }, { merge: true });

    res.status(200).send(JSON.stringify({ "message": "Success" }));
  } catch (error) {
    console.error("Error unfollowing club:", error);
    res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
  }
}

const updateProfileImage = async (req, res) => {
  try {
    const { uid, image } = req.body;
    
    // Check if 'image' is defined
    if (!image || !uid) {
      return res.status(400).send("Image data or UID not provided");
    }

    const storage = getStorage();
    const storageRef = ref(storage, `users/${uid}/${Date.now()}.png`);

    // Convert the base64 string to a buffer
    const buffer = Buffer.from(image, 'base64');

    // Use uploadBytes directly
    await uploadBytes(storageRef, buffer);

    try {
      // Wait for the download URL
      const URL = await getDownloadURL(storageRef);
      // Assuming you have a collection named 'users' in your Firestore
      await setDoc(doc(db, "users", uid), { downloadURL: URL }, { merge: true });
      res.status(200).send("Image uploaded successfully");
    } catch (error) {
      console.error(error);
      res.status(500).send("Error getting download URL");
    }
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
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
  getAllUsers,
  getUser,
  followPublicClub,
  followPrivateClub,
  unfollowClub,
  updateProfileImage
};