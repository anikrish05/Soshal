const controllers = require('../controllers/events')
const router = require('express').Router()
router.post('/createEvent', controllers.createEvent)
router.get('/getFeedPosts', controllers.getFeedPosts)

module.exports = router