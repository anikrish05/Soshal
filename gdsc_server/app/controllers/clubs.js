const { db, auth } = require('../../db/config');
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc, updateDoc } = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut } = require("firebase/auth");
const { uploadString, getDownloadURL, getStorage  } = require("firebase/storage");
const { checkAuthorization } = require('./authorizationUtil');
const { ref, uploadBytes } = require('firebase/storage');
const { Buffer } = require('buffer');
const multer = require('multer');
const multerStorage = multer.memoryStorage();
const multerUpload = multer({ storage: multerStorage });
async function addUserToClub(userId, clubId) {
  const docSnap = await getDoc(doc(db, "users", userId));

  data = {
    role: "owner",
    clubsOwned: [...docSnap.data().clubsOwned, clubId]
  }
  await updateDoc(doc(db, "users", userId), data)
}

const createClub = async (req, res) => {
  //hi
  if (await checkAuthorization(req, res)) {
    const { name, description, downloadURL, type, category, admin } = req.body;

    const data = {
      verified: false,
      name: name,
      description: description,
      downloadURL: downloadURL,
      type: type,
      category: category,
      followers: {},
      events: [],
      admin: admin,
      avgRating: 0
    }
    const clubCollection = collection(db, 'clubs');
    addDoc(clubCollection, data).then((docRef) => {
      for (var i = 0; i < admin.length; i++) {
        addUserToClub(admin[i], docRef.id)
      }
      res.status(200).send(JSON.stringify({ message: "Club Added" }))
    }).catch(error => {
      res.status(500).send(JSON.stringify({ message: "Failed" }))
    });
  }
}

const getClub = async (req, res) => {
  try {
    if (await checkAuthorization(req, res)) {
      const id = req.params.id;
      const docRef = await getDoc(doc(db, "clubs", id));
      const data = docRef.data()
      data.id = docRef.id
      res.status(200).send(JSON.stringify({ 'message': data }))
    }
  } catch (error) {
    console.error("Error getting document:", error);
    res.status(500).send(JSON.stringify({ message: "Failed", error: error.message }));
  }
};

const getDataForSearchPage = async (req, res) => {
  try {
    if (await checkAuthorization(req, res)) {
      let a = {}
      const clubRef = collection(db, "clubs");
      const eventsRef = collection(db, "events");
      const clubData = await getDocs(clubRef);
      const eventData = await getDocs(eventsRef);
      clubs = []
      clubData.forEach(doc => {
        clubs.push(doc.data())
        clubs[clubs.length - 1].id = doc.id
      })
      a.clubs = clubs
      events = []
      eventData.forEach(doc => {
        events.push(doc.data())
        events[events.length - 1].id = doc.id
      })
      a.events = events
      res.status(200).send(JSON.stringify({ 'message': a }))
    }
  } catch (error) {
    console.error("Error getting document:", error);
    res.status(500).send(JSON.stringify({ message: "Failed", error: error.message }));
  }
}

const getAllEventsForClub = async (req, res) => {
  const { eventIDS } = req.body;
  try {
    if (await checkAuthorization(req, res)) {
      let result = []
      for (const id of eventIDS) {
        docRef = await getDoc(doc(db, "events", id))
        data = docRef.data()
        data.id = docRef.id
        result.push(data);
      }
      res.status(200).send(JSON.stringify({ 'message': result }))
    }
  } catch (error) {
    console.error("Error getting document:", error);
    res.status(500).send(JSON.stringify({ message: "Failed", error: error.message }));
  }
}

const acceptUser = async (req, res) => {
  try {
    if (await checkAuthorization(req, res)) {
      const { clubId, uid } = req.body;
      const date = Date.now()
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
    }
  } catch (error) {
    console.error("Error following public club:", error);
    res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
  }
}

const denyUser = async (req, res) => {
  try {
    if (await checkAuthorization(req, res)) {
      const { clubId, uid } = req.body;
      const date = Date.now()

      // Update user's following field
      const userDocRef = doc(db, "users", uid);
      const userDoc = await getDoc(userDocRef);
      const userData = userDoc.data();

      // Assuming userData.following is a map
      userData.following[clubId] = ["Denied", date];

      await setDoc(userDocRef, { following: userData.following }, { merge: true });

      // Update club's followers field
      const clubDocRef = doc(db, "clubs", clubId);
      const clubDoc = await getDoc(clubDocRef);
      const clubData = clubDoc.data();

      // Assuming clubData.followers is a map
      clubData.followers[uid] = ["Denied", date];

      await setDoc(clubDocRef, { followers: clubData.followers }, { merge: true });

      res.status(200).send(JSON.stringify({ "message": "Success" }));
    }
  } catch (error) {
    console.error("Error following public club:", error);
    res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
  }
}

const getAllClubs = async (req, res) => {
  if (await checkAuthorization(req, res)) {
    try {
      let clubs = [];
      const clubsRef = collection(db, "clubs");
      const clubData = await getDocs(clubsRef);

      clubData.docs.map(doc => {
        var docData = doc.data()
        docData.id = doc.id
        clubs.push(docData)
      });

      res.status(200).send(JSON.stringify({ "message": clubs }));
    } catch (error) {
      console.error("Error getting document:", error);
      res.status(500).send(JSON.stringify({ message: "Failed", error: error.message }));
    }
  }
};

const updateClub = async(req, res) => {
  const {name, description, type, category, id} = req.body;
  await checkAuthorization(req, res);
  const clubDoc = doc(db, "clubs", id);
    await setDoc(clubDoc, { name: name, description: description, type: type, category: category }, { merge: true });
   res.status(200).send(JSON.stringify({'message':"success"}))
}

const updateClubImage = async (req, res) => {
  try {
    if (await checkAuthorization(req, res)) {
      const { id, image } = req.body;

      // Check if 'image' is defined
      if (!image || !uid) {
        return res.status(400).send("Image data or ID not provided");
      }

      const storage = getStorage();
      const storageRef = ref(storage, `clubs/${id}/${Date.now()}.png`);

      // Convert the base64 string to a buffer
      const buffer = Buffer.from(image, 'base64');

      // Use uploadBytes directly
      await uploadBytes(storageRef, buffer);

      try {
        // Wait for the download URL
        const URL = await getDownloadURL(storageRef);
        // Assuming you have a collection named 'users' in your Firestore
        await setDoc(doc(db, "clubs", id), { downloadURL: URL }, { merge: true });
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



module.exports = {
  createClub,
  getClub,
  getDataForSearchPage,
  getAllEventsForClub,
  acceptUser,
  denyUser,
  getAllClubs,
  updateClub,
  updateClubImage
};
