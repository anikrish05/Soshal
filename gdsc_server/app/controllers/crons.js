const { getFirestore, collection, getDocs, setDoc } = require('firebase/firestore');
const { db, auth } = require('../../db/config');
const { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut} = require("firebase/auth");
const axios = require('axios');
const serverKey = 'AAAAMEF6-KY:APA91bG2-CzCuAQCFvCbXx6G2YloxVaKAkVV3xCs-dcLYMJ2PKz91S-c1_KBkqAQtlMgAIbyV9v1Z7zTG3L04nV7lw7_Q-uipZs23SNTqBUN6c2Vhqkbl9V4zPRcvCm2evFKwDwxJKwH';
const fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';
function formatTimestampToDateTime(timestamp) {
  const date = new Date(timestamp);

  // Extract individual components
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are zero-based
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');

  // Format the result
  const formattedDateTime = `${year}-${month}-${day} ${hours}:${minutes}`;

  return formattedDateTime;
}

const cronsRepeatable = async (req, res) => {
  try {
     const userCredential = await signInWithEmailAndPassword(auth, "adminsdkuser.soshal@soshal.com", "Soshal123!");
    const eventsCollection = collection(db, 'events');
    const eventData = await getDocs(eventsCollection);

    eventData.docs.map(async (doc) => {
      const eventData = doc.data();
      console.log('eventData:', eventData);

      const timestampMilliseconds = new Date(eventData.timestamp).getTime();
      console.log('timestampMilliseconds:', timestampMilliseconds);

      if (eventData.repeat == true) {
        if (((eventData.timestamp - timestampMilliseconds) / (1000 * 60 * 60)) > 4) {
          // Use doc.ref to reference the document directly
          const oneWeekInMilliseconds = 7 * 24 * 60 * 60 * 1000;
          await setDoc(doc.ref, { timestamp: formatTimestampToDateTime(timestampMilliseconds + oneWeekInMilliseconds) }, { merge: true });
        }
      }
    });
    res.status(200).send({"message": "success"})
  } catch (error) {
    console.error('Error fetching events:', error);
  }
};

const cronsNotification = async (req, res) => {
  let success = false;

  try {
    const userCredential = await signInWithEmailAndPassword(auth, "adminsdkuser.soshal@soshal.com", "Soshal123!");
    const userCollection = collection(db, 'users');
    const devices = [];

    const userData = await getDocs(userCollection);

    for (const doc of userData.docs) {
      const userInfo = doc.data();
      if(userInfo.notifToken!=null){
        devices.push(userInfo.notifToken);
      }
    }

    const notificationPayload = {
      registration_ids: devices,
      notification: {
        title: 'Your Notification Title',
        body: 'Your Notification Body',
      },
    };

    const response = await axios.post(fcmEndpoint, notificationPayload, {
      headers: {
        Authorization: `key=${serverKey}`,
        'Content-Type': 'application/json',
      },
    });

    // Handle successful response
    console.log('Notification sent successfully:', response.data);
    success = true;
  } catch (error) {
    // Handle errors
    console.error('Error sending notification:', error.message);
    success = false;
  } finally {
    // Send the response outside the try-catch block
    if (success) {
      res.status(200).send({ message: 'success' });
    } else {
      res.status(500).send({ message: 'fail' });
    }
  }
};

module.exports = {
  cronsRepeatable,
  cronsNotification

};
