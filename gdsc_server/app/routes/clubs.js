const controllers = require('../controllers/clubs')
const router = require('express').Router()
router.post('/createClub', controllers.createClub)

module.exports = router