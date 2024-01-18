const { db, auth } = require('../../db/config');
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, addDoc, updateDoc } = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut } = require("firebase/auth");
const { uploadString, getDownloadURL, getStorage  } = require("firebase/storage");
const { checkAuthorization } = require('./authorizationUtil');
const axios = require('axios');
const serverKey = 'AAAAMEF6-KY:APA91bG2-CzCuAQCFvCbXx6G2YloxVaKAkVV3xCs-dcLYMJ2PKz91S-c1_KBkqAQtlMgAIbyV9v1Z7zTG3L04nV7lw7_Q-uipZs23SNTqBUN6c2Vhqkbl9V4zPRcvCm2evFKwDwxJKwH';
const fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';
async function addUserToGroup(userId, friendId) {
  const docSnap = await getDoc(doc(db, "users", userId));

  data = {
    friendGroups: [...docSnap.data().friendGroups, friendId]
  }
  await updateDoc(doc(db, "users", userId), data)
  return(docSnap.data().notifToken)
}

const createFriendGroup = async (req, res) => {
  if (await checkAuthorization(req, res)) {
    const { friendCircle, name } = req.body;
    var devices = [];
    const data = {
      friendCircle: friendCircle,
      name: name,
    }
    const friendCollection = collection(db, 'friends');
    addDoc(friendCollection, data).then(async (docRef) => {
      friendCircle.forEach(async (friend) => {
        var currDevice = await addUserToGroup(friendCircle[i], docRef.id)
        devices.push(currDevice)
      });
      const notificationPayload = {
        registration_ids: devices,
        notification: {
          title: 'Added to Friend Group',
          body: 'You Have Been Added to the Friend Group, '+name,
        },
       };

    const response = await axios.post(fcmEndpoint, notificationPayload, {
      headers: {
        Authorization: `key=${serverKey}`,
        'Content-Type': 'application/json',
      },
    });

      res.status(200).send(JSON.stringify({ message: "Friend Group Created" }))
    }).catch(error => {
      res.status(500).send(JSON.stringify({ message: "Failed" }))
    });
  }
}

module.exports = {
  createFriendGroup
};
