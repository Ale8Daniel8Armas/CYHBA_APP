const userService = require('../services/user_service.js');

exports.register = async(req, res, next) => {
    try {
        const {email,password} = req.body;
        const successRes = await userService.registerUser(email, password);

        res.status(200).json({
            status: true,
            success: "Usuario registrado satisfactoriamente"
        });
    } catch (error) {
        res.status(400).json({
            status: false,
            message: error.message
        });
    }
}