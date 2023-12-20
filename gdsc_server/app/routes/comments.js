const controllers = require('../controllers/comments')
const router = require('express').Router()

router.post('/getCommentDataForEvent', controllers.getCommentDataForEvent)
router.post('/addComment', controllers.addComment)
router.post('/likeComment', controllers.likeComment)
router.post('/disLikeComment', controllers.disLikeComment)

module.exports = router