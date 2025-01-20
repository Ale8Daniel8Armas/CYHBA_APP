const express = require('express');
const body_parser = require('body-parser');
const userRouter = require('../server/routers/user_router.js');

const app = express();

app.use(body_parser.json());

app.use('/', userRouter);

module.exports = app;