const { db, auth } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
async function associatedClubEventAdd(clubList, eventId) {
	for (const clubID of clubList){
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
	const {admin, name, description, downloadURL, latitude, longitude, timestamp, repeat} = req.body;
	const data = {
		name: name,
		admin: admin,
		comments: [],
		description: description,
		downloadURL: downloadURL,
		latitude: latitude,
		longitude: longitude,
		rating: 0,
		timestamp: timestamp,
		repeat: repeat,
		rsvpList: []
	}
	addDoc(collection(db, "events"), data).then((docRef)=>{
		associatedClubEventAdd(admin, docRef.id)
		res.status(200).send(JSON.stringify({ message: "Event Added"}))
	}).catch(error => {
        res.status(500).send(JSON.stringify({ message: "Failed"}))
	})
}

const getFeedPosts = async (req, res) => {
  try {
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
    res.status(500).send(JSON.stringify({ error: 'Internal Server Error' }));
  }
};

const getEvent = async (req, res) => {
  try {
    const id = req.params.id;
    const docRef = await getDoc(doc(db, "events", id));

    if (docRef.exists()) {
      const data = docRef.data();
      console.log(data);
      console.log(data.admin);
      console.log(data['admin']);

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
};



module.exports = {
	createEvent,
	getFeedPosts,
	getEvent
};