const app = require("../server/app.js");
const db = require("../server/config/db.js");
const userModel = require("../server/model/user_model.js");

const PORT = 4000;

app.get("/", (req, res) => {
  res.send("Hola Mundo !!");
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
});
