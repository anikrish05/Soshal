const controllers = require('../controllers/users')
const router = require('express').Router()
router.post('/signup', controllers.signup)
router.post('/login', controllers.login)
router.get('/signedIn', controllers.signedIn)
router.get('/signOut', controllers.signout)
router.get('/userData',controllers.userData)
router.post('/rsvp', controllers.login)
router.post('/deRSVP', controllers.login)

module.exports = router