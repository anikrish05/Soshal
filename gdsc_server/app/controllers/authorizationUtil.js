const { db, auth } = require('../../db/config')

const checkAuthorization = async (req, res) => {
  auth.verifyIdToken(idToken)
  .then((decodedToken) => {
    return true
  })
  .catch((error) => {
    return false
    // Handle error
  });
};

module.exports = { checkAuthorization };
