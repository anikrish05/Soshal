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
	const {id} = req.body;
	getDoc(doc(db, "clubs", id)).then((data)=>{
        res.status(200).send(JSON.stringify({'message':data.data()}))

	})

}
module.exports = {
	createClub,
	getClub
};