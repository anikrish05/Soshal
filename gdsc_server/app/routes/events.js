const controllers = require('../controllers/events')
const router = require('express').Router()
router.post('/createEvent', controllers.createEvent)
router.get('/getFeedPosts/:uid', controllers.getFeedPosts)
router.get('/getEvent/:id', controllers.getEvent)

module.exports = router