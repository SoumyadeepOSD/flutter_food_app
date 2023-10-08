const mongoose = require('mongoose');

const authSchema = mongoose.Schema(
    {
        mobile:{
            required: true,
            type: String,
        }
    }
);


const AuthSchema = mongoose.model('users', authSchema);
module.exports = AuthSchema;