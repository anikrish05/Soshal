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
  result = [];
  const { comments } = req.body;
  
  for (var i = 0; i < comments.length; i++) {
    const commentDoc = doc(db, "comments", comments[i]);
    
    // Get the comment ID using commentDoc.id
    const commentID = commentDoc.id;

    const commentData = (await getDoc(commentDoc)).data();
    commentData.commentID = commentID;
    
    // Assuming you have a function to get associated user data
    commentData.userData = await getAssociatedUserForComment(commentData.user);
    
    result.push(commentData);
  }

  res.status(200).send(JSON.stringify({ message: result }));
}


const addComment = async (req, res) => {
	const { commentData, eventID } = req.body;
	let data = JSON.parse(commentData)
	data.likedBy = []
	const myCollection = collection(db, 'comments');
	const newDocRef = await addDoc(myCollection, data);
	associatedEventCommentAdd(newDocRef.id, eventID)
	res.status(200).send(JSON.stringify({ message: newDocRef.id}))

}

const likeComment = async (req, res) => {
	const { uid, commentID } = req.body;
	const commentDoc = doc(db, "comments", commentID);
    const commentData = (await getDoc(commentDoc)).data();
    const updatedLikes = commentData.likedBy ? [...commentData.likedBy, uid] : [uid];
    await setDoc(commentDoc, { likedBy: updatedLikes }, { merge: true });

}

const disLikeComment = async (req, res) => {
	const { uid, commentID } = req.body;
	const commentDoc = doc(db, "comments", commentID);
    const commentData = (await getDoc(commentDoc)).data();
	const updatedLikes = commentData.likedBy ? commentData.likedBy.filter(item => item !== uid) : [];
	await setDoc(commentDoc, { likedBy: updatedLikes }, { merge: true });
}



module.exports = {
	getCommentDataForEvent,
	addComment,
	likeComment,
	disLikeComment

};