const controllers = require('../controllers/crons')
const router = require('express').Router()

router.post('/cronsRepeatable', controllers.cronsRepeatable)


module.exports = router