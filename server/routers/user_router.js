const router = require('express').Router();
const UserController = require('../controller/user_controller.js');

router.post('/registration', UserController.register);

module.exports = router;