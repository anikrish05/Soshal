const { db, auth } = require('../../db/config');
const { checkAuthorization } = require('./authorizationUtil');

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
        const { admin, name, description, downloadURL, latitude, longitude, timestamp, repeat, tags } = req.body;
        const data = {
            name: name,
            admin: admin,
            comments: [],
            description: description,
            downloadURL: downloadURL,
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
                res.status(200).send(JSON.stringify({ message: "Event Added" }));
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

const deleteEvent = async (req, res) => {
    if (await checkAuthorization(req, res)) {
        const { eventID } = req.body;

        await deleteDoc(doc(db, "events". eventID));


    }
}

module.exports = {
    createEvent,
    getFeedPosts,
    getEvent,
    deleteEvent
};
