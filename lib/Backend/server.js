const userModel = require('./models/userModel');
const express = require('express');
const mongoose = require('mongoose');

const password = encodeURIComponent('Bhowmick@69');
const PORT = 8000;
const URL = `mongodb+srv://SoumyadeepOSD:${password}@cluster0.1i9k0fc.mongodb.net/foody?retryWrites=true&w=majority`;

const app = express();
app.use(express.json());

// *Initial Routes*
app.get('/', (req, res) => {
    res.send('Hello World!');
});



// *Register a single user*
app.post('/register', async (req, res, next) => {
    const existingUser = await userModel.findOne({ mobile: req.body.mobile });
    if (existingUser) {
        return res.status(400).json({ message: 'User already exists' });
    } else {
        try {
            const user = await userModel.create(req.body);
           return res.status(200).json(user);
        } catch (error) {
            console.log(error.message);
            return res.status(500).json({ message: error.message });
        }
    }
    next();
});

// *Login user*
app.post('/login', async (req, res, next) => {
    const existingUser = await userModel.findOne({ mobile: req.body.mobile });
    if (existingUser) {
        try {
            return res.status(200).json({ message: "Successfully logged in" });
            next();
        } catch (error) {
            console.log(error.message);
            return res.status(500).json({ message: error.message });
        }
    next();
    } else {
        res.status(400).json({ message: "User is not created" })
    }

});

// *Get all users info*
app.get('/home', async (req, res) => {
    try {
        const users = await userModel.find({});
        res.status(200).json(users);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: error.message });
    }
});

// *Connect with MongoDB*
async function connect() {
    try {
        mongoose.connect(URL).then(() => {
            console.log('Connected to MongoDB');
        });
    } catch (error) {
        console.log(error);
    }
};
// *Listen to specific port*
app.listen(PORT, () => {
    console.log(`Example app listening on port ${PORT}!`);
});

connect();

