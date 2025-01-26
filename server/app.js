const express = require('express');
const body_parser = require('body-parser');
const userRouter = require('../server/routers/user_router.js');

const app = express();

// CORS middleware
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});


app.use(body_parser.json());

app.use('/', userRouter);

module.exports = app;