const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require("bcrypt");

const { Schema } = mongoose;

const userSchema = new Schema({
    nombre: {
        type: String,
        required: false,
        trim: true
    },
    email: {
        type: String,
        lowercase: true,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
    edad: {
        type: Number,
        required: false,
        min: 18,
        max: 80
    },
    genero: {
        type: String,
        required: false,
        enum: ['Masculino', 'Femenino', 'Otro']
    },
    localidad: {
        type: String,
        required: false,
        enum: ['Rural', 'Urbano', 'Sub-Urbano']
    },
    ocupacion: {
        type: String,
        required: false,
        enum: ['Empleado', 'Desempleado', 'Estudiante', 'Jubilado']
    },
});

userSchema.pre('save', async function () {
    try {
        var user = this;
        const salt = await bcrypt.genSalt(10);
        const hashpass = await bcrypt.hash(user.password, salt);
        user.password = hashpass;
    } catch (err) {
        throw err;
    }
});

userSchema.methods.comparePassword = async function (userPassword) {
    try {
        return await bcrypt.compare(userPassword, this.password);
    } catch (err) {
        throw err;
    }
}

const UserModel = db.model('user', userSchema);

module.exports = UserModel;
