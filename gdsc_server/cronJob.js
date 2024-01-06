// cronJob.js
import { collection, getDocs, setDoc } from 'firebase/firestore';
import { admin } from './db/config'; // Adjust the path accordingly

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

// Your logic to retrieve events and update timestamps
async function processEvents() {
  const timestamp = Date.now();
  // Logic to retrieve events from Firebase
  const eventRef = collection(admin.firestore(), 'events'); // Use admin.firestore() instead of db
  const eventData = await getDocs(eventRef);

  eventData.docs.map(async (doc) => {
    var eventData = doc.data();
    const timestampMilliseconds = new Date(eventData.timestamp).getTime();
    if (eventData.repeat == true) {
      if (((timestamp - timestampMilliseconds) / (1000 * 60 * 60)) > 4) {
        const oneWeekInMilliseconds = 7 * 24 * 60 * 60 * 1000;
        await setDoc(doc.ref, { timestamp: formatTimestampToDateTime(timestampMilliseconds + oneWeekInMilliseconds) }, { merge: true });
      }
    }
  });

  console.log('Cron job completed successfully.');
}

// Execute the function when the cron job runs
processEvents();
