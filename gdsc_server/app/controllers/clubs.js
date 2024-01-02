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
		followers: {},
		events: [],
		admin: admin,
		avgRating: 0
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
    const data = docRef.data()
    data.id = docRef.id
        res.status(200).send(JSON.stringify({'message':data}))
   
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

const getAllEventsForClub = async (req, res) => {
	const {eventIDS} = req.body;
	try{
		let result = []
		for(const id of eventIDS){
			docRef = await getDoc(doc(db, "events", id))
			data = docRef.data()
			data.id = docRef.id
			result.push(data);
		}
		res.status(200).send(JSON.stringify({'message':result}))


	} catch(error){
		console.error("Error getting document:", error);
    res.status(500).send(JSON.stringify({ message: "Failed", error: error.message }));
	}
}

const acceptUser = async (req, res) => {
  try {
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
  } catch (error) {
    console.error("Error following public club:", error);
    res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
  }
}

const denyUser = async (req, res) => {
  try {
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
  } catch (error) {
    console.error("Error following public club:", error);
    res.status(500).send(JSON.stringify({ "message": "Failed", "error": error.message }));
  }
}

module.exports = {
	createClub,
	getClub,
	getDataForSearchPage,
	getAllEventsForClub,
	acceptUser,
	denyUser
};