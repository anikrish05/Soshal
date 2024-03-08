const { db, auth, storage } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
const { uploadString, getDownloadURL, getStorage  } = require("firebase/storage");
const admin = require('firebase-admin');
const { checkAuthorization } = require('./authorizationUtil');

const { ref, uploadBytes } = require('firebase/storage');
const { Buffer } = require('buffer');
const multer = require('multer');
const multerStorage = multer.memoryStorage();
const multerUpload = multer({ storage: multerStorage });

const signup = async (req, res) => {
  try {
    const { email, password, name, classOf, token } = req.body;
    const userCredential = await createUserWithEmailAndPassword(auth, email, password);
    const user = userCredential.user;

    const data = {
      uid: user.uid,
      downloadURL: "",
      following: {},
      displayName: name,
      role: "user",
      email: email,
      myEvents: [],
      clubsOwned: [],
      classOf: classOf,
      notifToken: token,
      dislikedEvents: [],
      likedEvents: [],
      friendGroups: [],
      interestedTags: []
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
    const { email, password, token } = req.body;
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    const user = userCredential.user;
    await setDoc(doc(db, "users", user.uid), {notifToken: token}, { merge: true });

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

const signedIn = async (req, res) => {
  const idToken = req.headers['authorization'];
  if (idToken != null) {
    try {
      const userToken = await auth.currentUser.getIdToken();
      if (userToken !== idToken) {
        res.status(401).send(JSON.stringify({ message: false }));
      } else {
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        const uid = decodedToken.uid;
        const user = await admin.auth().getUser(uid);

        res.status(200).send(JSON.stringify({ message: user }));
      }
    } catch (error) {
      console.error('Error checking authorization:', error);
        res.status(401).send(JSON.stringify({ message: false }));
      return false; // Return false in case of an error
    }
  } else {
    res.status(401).send(JSON.stringify({ message: false }));
  }
};



const signout = async (req, res) => {
  if (await checkAuthorization(req, res)) {
    try {
      await signOut(auth);
      res.status(200).send(JSON.stringify({ message: "Signed Out" }));
    } catch (error) {
      res.status(500).send(JSON.stringify({ message: error.message }));
    }
  }
};


const userData  = async (req, res) => {
  if (await checkAuthorization(req, res)) {
      const idToken = req.headers['authorization'];

     const decodedToken = await admin.auth().verifyIdToken(idToken);
         getDoc(doc(db, "users", decodedToken.uid)).then((data)=>{
          res.status(200).send(JSON.stringify({'message':data.data()}))
        })
        }
}

const rsvp = async (req, res) => {
  if (await checkAuthorization(req, res)) {
    const { uid, eventID } = req.body;
    const userDoc = doc(db, "users", uid);
    const userData = (await getDoc(userDoc)).data();
    const updatedRSVP = userData.myEvents ? [...userData.myEvents, eventID] : [eventID];
    await setDoc(userDoc, { myEvents: updatedRSVP }, { merge: true });
    res.status(200).send(JSON.stringify({'message':"success"}));
  }
}

const deRSVP = async (req, res) => {
  if (await checkAuthorization(req, res)) {
    const { uid, eventID } = req.body;
    const userDoc = doc(db, "users", uid);
    const userData = (await getDoc(userDoc)).data();
    const updatedRSVP = userData.myEvents ? userData.myEvents.filter(item => item !== eventID) : [];
    await setDoc(userDoc, { myEvents: updatedRSVP }, { merge: true });
    res.status(200).send(JSON.stringify({'message':"success"}));
  }
}


const updateProfile = async(req, res) => {
  const {displayName, classOf, uid, interestedTags} = req.body;
  await checkAuthorization(req, res);
  const userDoc = doc(db, "users", uid);
    const userData = (await getDoc(userDoc)).data();
    await setDoc(userDoc, { displayName: displayName, classOf: classOf, interestedTags: interestedTags }, { merge: true });
   res.status(200).send(JSON.stringify({'message':"success"}))

}

const getAllUsers = async (req, res) => {
  if (await checkAuthorization(req, res)) {
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
  }
};

const getUser = async (req, res) => {
  if (await checkAuthorization(req, res)) {
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
};


const followPublicClub = async (req, res) => {
  if (await checkAuthorization(req, res)) {
    try {
      const { clubId, uid } = req.body;
      const date = Date.now();

      // Update user's following field
      const userDocRef = doc(db, "users", uid);
      const userDoc = await getDoc(userDocRef);
      const userData = userDoc.data();

      // Assuming userData.following is a map
      userData.following[clubId] = ["Accepted", date];

      await setDoc(userDocRef, { following: userData.following }, { merge: true });

      // Update club's followers field
      const clubDocRef = doc(db, "clubs", clubId);
      const clubDoc = await getDoc(clubDocRef);
      const clubData = clubDoc.data();

      // Assuming clubData.followers is a map
      clubData.followers[uid] = ["Accepted", date];

      await setDoc(clubDocRef, { followers: clubData.followers }, { merge: true });

      res.status(200).send(JSON.stringify({ "message": "Success" }));
    } catch (error) {
      console.error("Error following public club:", error);
      res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
    }
  }
};

const followPrivateClub = async (req, res) => {
  if (await checkAuthorization(req, res)) {
    try {
      const { clubId, uid } = req.body;
      const date = Date.now();

      // Update user's following field
      const userDocRef = doc(db, "users", uid);
      const userDoc = await getDoc(userDocRef);
      const userData = userDoc.data();

      // Assuming userData.following is a map
      userData.following[clubId] = ["Requested", date];

      await setDoc(userDocRef, { following: userData.following }, { merge: true });

      // Update club's followers field
      const clubDocRef = doc(db, "clubs", clubId);
      const clubDoc = await getDoc(clubDocRef);
      const clubData = clubDoc.data();

      // Assuming clubData.followers is a map
      clubData.followers[uid] = ["Requested", date];

      await setDoc(clubDocRef, { followers: clubData.followers }, { merge: true });

      res.status(200).send(JSON.stringify({ "message": "Success" }));
    } catch (error) {
      console.error("Error following public club:", error);
      res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
    }
  }
};


const unfollowClub = async (req, res) => {
  try {
    if (await checkAuthorization(req, res)) {
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
    }
  } catch (error) {
    console.error("Error unfollowing club:", error);
    res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
  }
};

const updateProfileImage = async (req, res) => {
  try {
    if (await checkAuthorization(req, res)) {
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
    }
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
};


const likeEvent = async (req, res) => {
  try {
    if (await checkAuthorization(req, res)) {
      const { uid, eventID } = req.body;

      // Update user's liked events
      const userDocRef = doc(db, "users", uid);
      const userDoc = await getDoc(userDocRef);
      const userData = userDoc.data();
     const updatedDisLikeEvents = userData.dislikedEvents ? userData.dislikedEvents.filter(event => event !== eventID) : [];

      const updatedLikeEvents = userData.likedEvents ? [...userData.likedEvents, eventID] : [eventID];
      await setDoc(userDocRef, { likedEvents: updatedLikeEvents }, { merge: true });
      await setDoc(userDocRef, { dislikedEvents: updatedDislikedEvents }, { merge: true });

      // Update event's liked by users
      const eventDocRef = doc(db, "events", eventID);
      const eventDoc = await getDoc(eventDocRef);
      const eventData = eventDoc.data();
      const updatedLikedBy = eventData.likedBy ? [...eventData.likedBy, uid] : [uid];
      const updatedDisLikedBy = eventData.dislikedEvents ? eventData.dislikedEvents.filter(allUIDS => allUIDS !== uid) : [];

      await setDoc(eventDocRef, { likedBy: updatedLikedBy }, { merge: true });
      await setDoc(eventDocRef, { disLikedBy: updatedDisLikedBy }, { merge: true });

      res.status(200).send(JSON.stringify({ "message": "Success" }));
    }
  } catch (error) {
    console.error("Error liking event:", error);
    res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
  }
};

const dislikeEvent = async (req, res) => {
  try {
    if (await checkAuthorization(req, res)) {
      const { uid, eventID } = req.body;

      // Update user's liked events
      const userDocRef = doc(db, "users", uid);
      const userDoc = await getDoc(userDocRef);
      const userData = userDoc.data();
      const updatedLikeEvents = userData.likedEvents ? userData.likedEvents.filter(event => event !== eventID) : [];
      const updatedDislikedEvents = userData.dislikedEvents ? [...userData.dislikedEvents, eventID] : [eventID];
      await setDoc(userDocRef, { likedEvents: updatedLikeEvents }, { merge: true });
      await setDoc(userDocRef, { dislikedEvents: updatedDislikedEvents }, { merge: true });

      // Update event's liked by users
      const eventDocRef = doc(db, "events", eventID);
      const eventDoc = await getDoc(eventDocRef);
      const eventData = eventDoc.data();
      const updatedLikedBy = eventData.likedBy ? eventData.likedBy.filter(allUIDS => allUIDS !== uid) : [];
     const updatedDisLikedBy = eventData.disLikedBy ? [...eventData.disLikedBy, uid] : [uid];

      await setDoc(eventDocRef, { likedBy: updatedLikedBy }, { merge: true });
      await setDoc(eventDocRef, { disLikedBy: updatedDisLikedBy }, { merge: true });

      res.status(200).send(JSON.stringify({ "message": "Success" }));
    }
  } catch (error) {
    console.error("Error disliking event:", error);
    res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
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
  updateProfileImage,
  likeEvent,
  dislikeEvent
};