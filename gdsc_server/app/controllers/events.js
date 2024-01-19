const { db, auth } = require('../../db/config');
const { checkAuthorization } = require('./authorizationUtil');
const { uploadString, getDownloadURL, getStorage  } = require("firebase/storage");
const { ref, uploadBytes } = require('firebase/storage');
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc, deleteDoc } = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut, verifyIdToken } = require("firebase/auth");

async function associatedClubEventAdd(clubList, eventId) {
    for (const clubID of clubList) {
        const clubDoc = doc(db, "clubs", clubID);
        const clubData = (await getDoc(clubDoc)).data();
        const updatedEvents = clubData.events ? [...clubData.events, eventId] : [eventId];
        await setDoc(clubDoc, { events: updatedEvents }, { merge: true });
    }
}

async function getAssociatedClubForEvent(admin) {
    const clubInfo = [];
    for (const clubId of admin) {
        const clubDoc = doc(db, "clubs", clubId);
        const clubData = (await getDoc(clubDoc)).data();
        clubData.id = clubDoc.id
        clubInfo.push(clubData);
    }
    return clubInfo;
}

const createEvent = async (req, res) => {
    if (await checkAuthorization(req, res)) {
        const { admin, name, description, latitude, longitude, timestamp, repeat, tags } = req.body;
        const data = {
            name: name,
            admin: admin,
            comments: [],
            description: description,
            latitude: latitude,
            longitude: longitude,
            timestamp: timestamp,
            repeat: repeat,
            rsvpList: [],
            tags: tags,
            likedBy: [],
            disLikedBy: [],
        };
        addDoc(collection(db, "events"), data)
            .then((docRef) => {
                associatedClubEventAdd(admin, docRef.id);
                res.status(200).send(JSON.stringify({ message: docRef.id }));
            })
            .catch(error => {
                res.status(500).send(JSON.stringify({ message: "Failed" }));
            });
    }
}

const getFeedPosts = async (req, res) => {
    if (await checkAuthorization(req, res)) {
        try {
            const uid = req.params.uid
            const colRef = collection(db, "events");
            const docsSnap = await getDocs(colRef);
            const allDocs = [];

            for (const doc of docsSnap.docs) {
                const data = doc.data();
                data.eventID = doc.id;
                data.clubInfo = await getAssociatedClubForEvent(data.admin);
                allDocs.push(data);
            }

            res.status(200).send(JSON.stringify({ message: allDocs }));
        } catch (error) {
            console.error('Error in getFeedPosts:', error);
            // If verification fails, return an unauthorized status
        }
    }
};

const getEvent = async (req, res) => {
    if (await checkAuthorization(req, res)) {
        try {
            const id = req.params.id;
            const docRef = await getDoc(doc(db, "events", id));

            if (docRef.exists()) {
                const data = docRef.data();

                // Assuming getAssociatedClubForEvent is an asynchronous function
                data.clubInfo = await getAssociatedClubForEvent(data.admin);

                res.status(200).send(JSON.stringify({ 'message': data }));
            } else {
                res.status(404).send(JSON.stringify({ 'message': 'Event not found' }));
            }
        } catch (error) {
            console.error("Error getting document:", error);
            res.status(500).send(JSON.stringify({ message: "Failed", error: error.message }));
        }
    }
};

const updateEvent = async(req, res) => {
  const {name, description, latitude, longitude, timestamp, repeat, id} = req.body;
  await checkAuthorization(req, res);
  const clubDoc = doc(db, "events", id);
    await setDoc(clubDoc, { name: name, description: description, latitude: latitude, longitude: longitude, timestamp: timestamp, repeat: repeat }, { merge: true });
   res.status(200).send(JSON.stringify({'message':"success"}))
};

const updateEventImage = async (req, res) => {
  try {
    if (await checkAuthorization(req, res)) {
      const { id, image } = req.body;

      // Check if 'image' is defined
      if (!image || !id) {
        return res.status(400).send("Image data or ID not provided");
      }

      const storage = getStorage();
      const storageRef = ref(storage, `events/${id}/${Date.now()}.png`);

      // Convert the base64 string to a buffer
      const buffer = Buffer.from(image, 'base64');

      // Use uploadBytes directly
      await uploadBytes(storageRef, buffer);

      try {
        // Wait for the download URL
        const URL = await getDownloadURL(storageRef);
        // Assuming you have a collection named 'users' in your Firestore
        await setDoc(doc(db, "events", id), { downloadURL: URL }, { merge: true });
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


const deleteEvent = async (req, res) => {
    if (await checkAuthorization(req, res)) {
        const { eventID } = req.body;
        const eventDoc = await getDoc(doc(db, "events", eventID));
        const clubCollection = collection(db, "clubs")
        const userCollection = collection(db, "users")
        const eventData = eventDoc.data()
        eventData.admin.forEach(async (clubID) =>{
            const tempClub = (await getDoc(doc(db, "clubs", clubID))).data();
            await setDoc(doc(db, "clubs", clubID), { events: tempClub.events.filter(item => item !== clubID) }, { merge: true });
        });
        eventData.disLikedBy.forEach(async (userID) =>{
            const tempUser = (await getDoc(doc(db, "users", userID))).data();
            await setDoc(doc(db, "users", userID), { dislikedEvents: tempUser.dislikedEvents.filter(item => item !== eventID) }, { merge: true });
        });
        eventData.likedBy.forEach(async (userID) =>{
            const tempUser = (await getDoc(doc(db, "users", userID))).data();
            await setDoc(doc(db, "users", userID), { likedEvents: tempUser.likedEvents.filter(item => item !== eventID) }, { merge: true });
        });
        eventData.rsvpList.forEach(async (userID) =>{
            const tempUser = (await getDoc(doc(db, "users", userID))).data();
            await setDoc(doc(db, "users", userID), { myEvents: tempUser.myEvents.filter(item => item !== eventID) }, { merge: true });
        });
        eventData.comments.forEach(async (commentID) =>{
            await deleteDoc(doc(db, "comments", commentID))
        });
        res.status(200).send({"message": "success"})
    }
}

module.exports = {
    createEvent,
    getFeedPosts,
    getEvent,
    deleteEvent,
    updateEventImage,
    updateEvent
};
