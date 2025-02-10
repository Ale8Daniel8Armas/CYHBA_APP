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
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await userService.checkuser(email);

    if (!user) {
      throw new Error('Usuario no existe');
    }

    const isMatch = await user.comparePassword(password);

    if (!isMatch) {
      throw new Error('Contraseña inválida');
    }

    const tokenData = { _id: user._id, email: user.email };
    const token = await userService.generateToken(tokenData, "secretkey", "1h");

    res.status(200).json({ status: true, token });
  } catch (error) {
    res.status(400).json({ status: false, message: error.message });
  }
};

      exports.updateUserDataByAgeNameGender = async (req, res) => {
        try {
            const { email, nombre, edad, genero } = req.body;
            const updatedUser = await userService.updateUserDataByAgeNameGender(email, nombre, edad, genero);
    
            res.status(200).json({
                status: true,
                message: "Datos actualizados correctamente",
                user: { email: updatedUser.email, nombre: updatedUser.nombre, edad: updatedUser.edad, genero: updatedUser.genero }
            });
        } catch (error) {
            res.status(400).json({ status: false, message: error.message });
        };
    };

        exports.updateUserDataByLocalOcupation = async (req, res) => {
            try {
                const { email, localidad, ocupacion } = req.body;
                const updatedUser = await userService.updateUserDataByLocalOcupation(email, localidad, ocupacion);
        
                res.status(200).json({
                    status: true,
                    message: "Datos ocupacion y localidad actualizados",
                    user: { email: updatedUser.email, localidad: updatedUser.localidad, ocupacion: updatedUser.ocupacion }
                });
            } catch (error) {
                res.status(400).json({ status: false, message: error.message });
            }
};

