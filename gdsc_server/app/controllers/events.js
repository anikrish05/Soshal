const { db, auth } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
async function associatedClubEventAdd(club, eventId) {
    const clubDoc = doc(db, "clubs", club);
    const clubData = (await getDoc(clubDoc)).data();
    const updatedEvents = clubData.events ? [...clubData.events, eventId] : [eventId];
    await setDoc(clubDoc, { events: updatedEvents }, { merge: true });
}

async function getAssociatedClubForEvent(admin) {
    const clubInfo = [];
    for (const clubId of admin) {
        const clubDoc = doc(db, "clubs", clubId);
        const clubData = (await getDoc(clubDoc)).data();
        clubInfo.push(clubData);
    }
    return clubInfo;
}

const createEvent = async (req, res) => {
	const {name, description, image, location, time, repeat, associatedClub} = req.body;
	const data = {
		name: name,
		description: description,
		image: image,
		location: location,
		time: time,
		repeat: repeat,
		rsvpList: []
	}
	addDoc(doc(db, "events"), data).then((docRef)=>{
		associatedClubEventAdd(associatedClub, docRef.id)
		res.status(200).send(JSON.stringify({ message: "Event Added"}))
	}).catch(error => {
        res.status(500).send(JSON.stringify({ message: "Failed"}))
	})
}

const getFeedPosts = async (req, res) => {
	const colRef = collection(db, "events");
	const docsSnap = await getDocs(colRef);
	allDocs = []
	docsSnap.forEach(doc => {
		data = doc.data()
		data.eventID = doc.id
		data.clubInfo = getAssociatedClubForEvent(data.admin)
		allDocs.push(data)
	res.status(200).send(JSON.stringify({ message: allDocs}))
	})
}

module.exports = {
	createEvent,
	getFeedPosts
};