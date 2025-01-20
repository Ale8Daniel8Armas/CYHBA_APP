const userService = require('../services/user_service.js');

exports.register = async(req, res, next) => {
    try{
        const {email,password} = req.body;

        const successRes = await userService.registerUser( email, password );

        res.json({status:true, success:"Usuario registrado satisfactoriamente"});
    } catch (error) {
        throw error;
    }
}