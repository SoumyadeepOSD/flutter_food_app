const mongoose = require("mongoose");
const dotenv = require('dotenv');
dotenv.config();

const URL = process.env.MONGO_URL;

const Connect = async () =>{
    try {
        mongoose.connect(URL).then(() => {
            console.log('Connected to MongoDB');
        });
    } catch (error) {
        console.log(error);
    }
};

module.exports = Connect;