const { db, auth } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
async function associatedClubEventAdd(club, eventId){
	const doc = getDoc(doc(db, "clubs", club))
	data = {
		events: doc.data().events.push(eventId)
	}
	await updateDoc(doc(db, "clubs", club), data)
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
	docsSnap.forEach(doc => {allDocs.push(doc.data())})
	res.status(200).send(JSON.stringify({ message: allDocs}))
}

module.exports = {
	createEvent,
	getFeedPosts
};