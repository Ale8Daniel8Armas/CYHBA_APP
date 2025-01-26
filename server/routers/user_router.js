const router = require('express').Router();
const UserController = require('../controller/user_controller.js');

router.post('/registro', UserController.register);


module.exports = router;