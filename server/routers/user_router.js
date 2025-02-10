const router = require('express').Router();
const UserController = require('../controller/user_controller.js');

router.post('/registro', UserController.register);
router.post('/login', UserController.login);
router.put('/updateNAG', UserController.updateUserDataByAgeNameGender);
router.put('/updateLO', UserController.updateUserDataByLocalOcupation);

module.exports = router;