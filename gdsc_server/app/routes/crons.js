const controllers = require('../controllers/crons')
const router = require('express').Router()

router.get('/cronsRepeatable', controllers.cronsRepeatable)

router.get('/cronsNotification', controllers.cronsNotification)

module.exports = router