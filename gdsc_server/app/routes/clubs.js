const controllers = require('../controllers/clubs')
const router = require('express').Router()
router.post('/createClub', controllers.createClub)
router.get('/getClub/:id', controllers.getClub)
router.post('/getAllEventsForClub', controllers.getAllEventsForClub)
router.get('/getDataForSearchPage', controllers.getDataForSearchPage)
router.post('/acceptUser', controllers.acceptUser)
router.post('/denyUser', controllers.denyUser)
router.get('/getAllClubs', controllers.getAllClubs)
router.post('/updateClub', controllers.updateClub)
router.post('/updateClubImage', controllers.updateClubImage)
module.exports = router
