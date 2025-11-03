const express = require('express');
const handler = require('../controllers/handler');

const router = express.Router();

router.get('/health', handler.healthCheck);
router.get('/data', handler.getData);

module.exports = router;