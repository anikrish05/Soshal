const controllers = require('../controllers/clubs')
const router = require('express').Router()
router.post('/createClub', controllers.createClub)
router.get('/getClub/:id', controllers.getClub)

module.exports = router
