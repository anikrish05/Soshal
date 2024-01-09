const { getFirestore, collection, getDocs, setDoc } = require('firebase/firestore');
const { admin } = require('../../db/config');

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
    const db = admin.firestore();
    const eventsCollection = collection(db, 'events');
    const eventData = await getDocs(eventsCollection);

    eventData.docs.map(async (doc) => {
      const eventData = doc.data();
      console.log('eventData:', eventData);

      const timestampMilliseconds = new Date(eventData.timestamp).getTime();
      console.log('timestampMilliseconds:', timestampMilliseconds);

      if (eventData.repeat == true) {
        if (((timestamp - timestampMilliseconds) / (1000 * 60 * 60)) > 4) {
          // Use doc.ref to reference the document directly
          const oneWeekInMilliseconds = 7 * 24 * 60 * 60 * 1000;
          await setDoc(doc.ref, { timestamp: formatTimestampToDateTime(timestampMilliseconds + oneWeekInMilliseconds) }, { merge: true });
        }
      }
    });
  } catch (error) {
    console.error('Error fetching events:', error);
  }
};




module.exports = {
  cronsRepeatable
};
