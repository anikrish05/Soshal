const { db, auth, admin} = require('../../db/config')

const checkAuthorization = async (req, res) => {
  const idToken = req.headers['authorization'];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    console.log(decodedToken.uid)
    console.log("success")
    // Handle success, you can use decodedToken.uid to get the user ID
    return true;
  } catch (error) {
    // Handle error
    console.error('Error verifying ID token:', error);
    return false;
  }
};

module.exports = { checkAuthorization };

