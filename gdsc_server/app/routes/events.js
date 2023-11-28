const controllers = require('../controllers/events')
const router = require('express').Router()
router.post('/createEvent', controllers.createEvent)

module.exports = router