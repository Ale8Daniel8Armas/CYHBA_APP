const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb://localhost:27017/cyhbaDB').on('open',()=>{
    console.log("Mongodb.Connection");
}).on('error',()=>{
    console.log("Mongodb connect error");
});

module.exports = connection;