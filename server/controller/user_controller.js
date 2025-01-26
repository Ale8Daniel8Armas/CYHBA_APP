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


