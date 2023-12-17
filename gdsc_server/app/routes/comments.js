const controllers = require('../controllers/comments')
const router = require('express').Router()

router.get('/getCommentDataForEvent', controllers.getCommentDataForEvent)
router.get('/addComment', controllers.addComment)

module.exports = router