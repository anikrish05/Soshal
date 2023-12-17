const { db, auth } = require('../../db/config')
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc, updateDoc} = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");

async function associatedEventCommentAdd(comentID, eventId) {
    const eventDoc = doc(db, "events", eventId);
    const eventData = (await getDoc(eventDoc)).data();
    const updatedComments = clubData.comments ? [...clubData.comments, comentID] : [comentID];
    await setDoc(eventDoc, { events: updatedComments }, { merge: true });
}

async function getAssociatedUserForComment(userID){
	const data = await getDoc(doc(db, "users", userID)) 
	return data;
}

const getCommentDataForEvent = async (req, res) => {
	result = []
	const { comments } = req.body;
	for(var i =0; i<comments.length; i++){
		    const commentDoc = doc(db, "comments", comments[i]);
        const commentData = (await getDoc(commentDoc)).data();
        commentData.userData = getAssociatedUserForComment(commentData.user)
        result.push(commentData);
	}

		res.status(200).send(JSON.stringify({ message: result}))

}

const addComment = async (req, res) => {
	const { commentData, eventID } = req.body;
	const myCollection = collection(db, 'comments');
	const newDocRef = await addDoc(myCollection, commentData);
	associatedEventCommentAdd(newDocRef.id, eventID)
	res.status(200).send(JSON.stringify({ message: "Comment Added"}))


}



module.exports = {
	getCommentDataForEvent,
	addComment
};