const UserModel = require('../model/user_model.js')

class UserService{
    static async registerUser(email, password){
        try{
            const createUser = new UserModel({email, password});
            return await createUser.save();
        }catch(err){
            throw err;
        }
    }
}

module.exports = UserService;