const UserModel = require('../model/user_model.js')
const jwt = require('jsonwebtoken');

class UserService{

    static async registerUser(email, password){
        try{
            const createUser = new UserModel({email, password});
            return await createUser.save();
        }catch(err){
            throw err;
        }
    }

    static async checkuser(email){
        try{
            return await UserModel.findOne({email});
        }catch (err) {
            throw err;
        }
    }

    static async generateToken(tokenData,secretkey,jwt_expire){
        return jwt.sign(tokenData,secretkey,{expiresIn:jwt_expire});
    }
}

module.exports = UserService;