const controllers = require('../controllers/users')
const router = require('express').Router()
router.post('/signup', controllers.signup)
router.post('/login', controllers.login)
router.get('/signedIn', controllers.signedIn)
router.get('/signOut', controllers.signout)
router.get('/userData',controllers.userData)
router.post('/rsvp', controllers.rsvp)
router.post('/deRSVP', controllers.deRSVP)
router.post('/updateProfile', controllers.updateProfile)

module.exports = router