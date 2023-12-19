const { db, auth } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc, updateDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");

async function associatedEventCommentAdd(comentID, eventId) {
    const eventDoc = doc(db, "events", eventId);
    const eventData = (await getDoc(eventDoc)).data();
    const updatedComments = eventData.comments ? [...eventData.comments, comentID] : [comentID];
    await setDoc(eventDoc, { comments: updatedComments }, { merge: true });
}

async function getAssociatedUserForComment(userID){
	const data = await getDoc(doc(db, "users", userID)) 
	return data.data();
}

const getCommentDataForEvent = async (req, res) => {
	result = []
	const { comments } = req.body;
	for(var i =0; i<comments.length; i++){
		    const commentDoc = doc(db, "comments", comments[i]);
        const commentData = (await getDoc(commentDoc)).data();
        commentData.userData = await getAssociatedUserForComment(commentData.user)
        result.push(commentData);
	}

		res.status(200).send(JSON.stringify({ message: result}))

}

const addComment = async (req, res) => {
	console.log("in side add comments")
	const { commentData, eventID } = req.body;
	let data = JSON.parse(commentData)
	data.likedBy = []
	const myCollection = collection(db, 'comments');
	const newDocRef = await addDoc(myCollection, data);
	associatedEventCommentAdd(newDocRef.id, eventID)
	res.status(200).send(JSON.stringify({ message: "Comment Added"}))

}



module.exports = {
	getCommentDataForEvent,
	addComment
};