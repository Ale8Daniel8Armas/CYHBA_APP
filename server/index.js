const app = require('../server/app.js');
const db = require('../server/config/db.js');
const userModel = require('../server/model/user_model.js');

const port = 4000;

app.get('/',(req,res)=>{
    res.send('Hola Mundo !!')
});

app.listen(port,()=>{
    console.log('Servidor escuchando en el puerto http://localhost:4000');
});
