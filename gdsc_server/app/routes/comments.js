const controllers = require('../controllers/comments')
const router = require('express').Router()

router.post('/getCommentDataForEvent', controllers.getCommentDataForEvent)
router.post('/addComment', controllers.addComment)

module.exports = router