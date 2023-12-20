const { db, auth } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc, updateDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
async function addUserToClub (userId, clubId,){
	const docSnap = await getDoc(doc(db, "users", userId));

	data = {
		role: "owner",
		clubsOwned: [...docSnap.data().clubsOwned, clubId]
	}
	await updateDoc(doc(db, "users", userId), data)
}

const createClub = async (req, res) => {
	const {name, description, downloadURL, type, category, admin} = req.body;
	const data = {
		verified: false,
		name: name,
		description: description,
		downloadURL: downloadURL,
		type: type,
		category: category,
		followers: [],
		events: [],
		admin: admin
	}
	const clubCollection = collection(db, 'clubs');
	  addDoc(clubCollection, data).then((docRef)=>{
	  	for(var i = 0; i<admin.length; i++){
	  		addUserToClub(admin[i], docRef.id)
	  	}
	  	res.status(200).send(JSON.stringify({ message: "Club Added"}))
	  }).catch(error => {
        res.status(500).send(JSON.stringify({ message: "Failed"}))
	})
}
const getClub = async (req, res) => {
  try {
    const id = req.params.id;
    const docRef = await getDoc(doc(db, "clubs", id));
        res.status(200).send(JSON.stringify({'message':docRef.data()}))
   
  } catch (error) {
    console.error("Error getting document:", error);
    res.status(500).send(JSON.stringify({ message: "Failed", error: error.message }));
  }
};

const getDataForSearchPage = async (req, res) => {
	try{
		let a = {}
		const clubRef = collection(db, "clubs");
		const eventsRef = collection(db, "events");
		const clubData = await getDocs(clubRef);
		const eventData = await getDocs(eventsRef);
		clubs = []
		clubData.forEach(doc => {
			clubs.push(doc.data())
			clubs[clubs.length-1].id = doc.id
		})
		a.clubs = clubs
		events = []
		eventData.forEach(doc => {
			events.push(doc.data())
			events[events.length-1].id = doc.id
		})
		a.events = events
    res.status(200).send(JSON.stringify({'message':a}))

	} catch (error){
		console.error("Error getting document:", error);
    res.status(500).send(JSON.stringify({ message: "Failed", error: error.message }));
	}
}

module.exports = {
	createClub,
	getClub,
	getDataForSearchPage
};