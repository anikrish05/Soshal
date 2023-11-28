const { db, auth } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
async function addUserToClub (userId, clubId){
	const docSnap = await getDoc(doc(db, "users", userId));
	data = {
		role: "owner",
		clubsOwned: docSnap.data().clubsOwned.push(clubId)
	}
	await updateDoc(doc(db, "users"), data)
}

const createClub = async (req, res) => {
	const {name, description, image, type, category} = req.body;
	const data = {
		verified: false,
		name: name,
		description: description,
		downloadURL: image,
		type: type,
		category: category,
		followers: [],
		events: [],
		admin: []
	}
	  addDoc(doc(db, "clubs"), data).then((docRef)=>{
	  	for(var i = 0; i<admin.length; i++){
	  		addUserToClub(admin[i], docRed.id)
	  	}
	  	res.status(200).send(JSON.stringify({ message: "Club Added"}))
	  }).catch(error => {
        res.status(500).send(JSON.stringify({ message: "Failed"}))
	})
}
module.exports = {
	createClub
};