const controllers = require('../controllers/events')
const router = require('express').Router()
router.post('/createEvent', controllers.createEvent)
router.get('/getFeedPosts/:uid', controllers.getFeedPosts)
router.get('/getEvent/:id', controllers.getEvent)
router.post('/updateEventImage', controllers.updateEventImage)
router.post('/updateEvent', controllers.updateEvent)

module.exports = router