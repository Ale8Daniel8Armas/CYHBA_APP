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

    // Función para actualizar nombre, edad y género
    static async updateUserDataByAgeNameGender(email, nombre, edad, genero) {
        try {
            const user = await UserModel.findOne({ email });
            if (!user) {
                throw new Error("Usuario no encontrado");
            }

            // Actualizar solo los valores proporcionados
            if (nombre) user.nombre = nombre;
            if (edad) user.edad = edad;
            if (genero) user.genero = genero;

            await user.save();
            return user;
        } catch (err) {
            throw err;
        }
    }

    // Función para actualizar localidad y ocupacion
    static async updateUserDataByLocalOcupation (email, localidad, ocupacion) {
        try {
            const user = await UserModel.findOne({ email });
            if (!user) {
                throw new Error("Usuario no encontrado en localidad y ocupacion");
            }

            // Actualizar solo los valores proporcionados
            if(localidad) user.localidad = localidad;
            if(ocupacion) user.ocupacion = ocupacion;

            await user.save();
            return user;
        } catch (err) {
            throw err;
        }
    }
}

module.exports = UserService;