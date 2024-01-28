const { db, auth } = require('../../db/config')

const checkAuthorization = async (req, res) => {
  const idToken = req.headers['authorization'];
  console.log(req.headers.referer)
  console.log(idToken)
  if(idToken!=null){
  try {
    // Get the current user's ID token from Firebase
    const userToken = await auth.currentUser.getIdToken();
    console.log(idToken)
    console.log(userToken)
    // Compare the user's ID token with the ID token provided in the request's authorization header
    if (userToken != idToken) {
      // If the tokens are different, the request is unauthorized
      console.log("token mismatch")
      res.status(401).send(JSON.stringify({ error: 'Unauthorized' }));
      return false; // Return false to indicate unauthorized
    }

    // If the tokens are the same, the user is authorized
    return true; // Return true to indicate authorized
  } catch (error) {
    console.log('Error checking authorization:', error);
    res.status(500).send(JSON.stringify({ error: 'Internal Server Error' }));
    return false; // Return false in case of an error
  }
}
else{
    res.status(401).send(JSON.stringify({ error: 'Unauthorized' }));
}
};

module.exports = { checkAuthorization };
