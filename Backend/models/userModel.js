const mongoose = require('mongoose');
const crypto = require("crypto");

const UserSchema = mongoose.Schema(
    {
        fullName:{
            required: true,
            type: String,
        },
        mobileNumber:{
            required: true,
            type: String,
            unique: true
        },
        email:{
            required: true,
            type: String,
            unique: true
        },
        isAdmin:{
            type: Boolean,
            default: false
        },
        password:{
            required: true,
            type: String,
        },
        profileImage:{
            type: String,
            default:"https://icon-library.com/images/anonymous-avatar-icon/anonymous-avatar-icon-25.jpg",
        },
        resetPasswordOTP: {
            type: String,
        },
        resetPasswordExpires: {
            type: Date,
        }
    }
);


const User = mongoose.model('users', UserSchema);
module.exports = User;