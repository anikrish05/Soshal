const controllers = require('../controllers/crons')
const router = require('express').Router()

router.get('/cronsRepeatable', controllers.cronsRepeatable)


module.exports = router