const AsyncHandler = require("express-async-handler");
const User = require("../models/userModel");
const dotenv = require("dotenv");
dotenv.config();
const generateToken = require("../utils/generateToken");
const bcrypt = require("bcryptjs");
const twilio = require("twilio");

const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = twilio(accountSid, authToken);



const sendOTP = async(mobileNumber, OTP)=>{
    try {
        await client.messages.create({
            body:`Your password reset OTP is ${OTP}`,
            from: process.env.TWILIO_NUMBER,
            to: `${mobileNumber}`
        });    
    } catch (error) {
        console.log(error);
    }
}


const generateOtp = ()=>{
    return Math.floor(100000 + Math.random() * 900000).toString();
}


const forgotPassword = AsyncHandler(async(req, res)=>{
    const {email} = req.body;
    if(!email){
        return res.status(400).json({message: "Please add all fields"});
    }
    const user = await User.findOne({email});
    if(!user){
        return res.status(404).json({message: "User not found"});
    }

    const otp = generateOtp();
    user.resetPasswordOTP = otp;
    user.resetPasswordExpires = Date.now() + 3600000;
    await user.save();

    await sendOTP(`+91${user.mobileNumber}`, otp);
    return res.status(200).json({message: "OTP sent"});
});

const verifyOTP = AsyncHandler(async(req, res)=>{
    const {email, otp} = req.body;
    const user = await User.findOne({email});

    if(!user || user.resetPasswordOTP!==otp || user.resetPasswordExpires<Date.now()){
        return res.status(400).json({message: "Invalid OTP"});
    }

    user.resetPasswordOTP = undefined;
    user.resetPasswordExpires = undefined;
    await user.save();
    return res.status(200).json({message: "OTP verified"});
});


const resetPassword = AsyncHandler(async (req, res) => {
    const { email, password } = req.body;
    const user = await User.findOne({ email });

    if (!user) {
        return res.status(404).json({ message: "User not found" });
    }

    try {
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);
        user.password = hashedPassword;
        await user.save();
        return res.status(200).json({ message: "Password reset" });
    } catch (error) {
        console.error(error.message);
        return res.status(500).json({ message: "Server error" });
    }
});


const Signup = AsyncHandler(async (req, res) => {
    const { fullName, mobileNumber, email, password, profileImage } = req.body;
    if (!fullName || !mobileNumber || !email || !password) {
        res.status(400);
        throw new Error("Please add all fields");
    }
    const userExists = await User.findOne({ mobileNumber });
    if (userExists) {
        return res.status(400).json({ message: 'User already exists' });
    }
    const salt = await bcrypt.genSalt(10);
    const hasedPassword = await bcrypt.hash(password,salt);
    try {
        const user = await User.create({ 
            fullName, 
            mobileNumber, 
            email, 
            password:hasedPassword, 
            profileImage });

        return res.status(201).json({
            _id: user._id,
            fullName: user.fullName,
            mobileNumber: user.mobileNumber,
            email: user.email,
            profileImage: user.profileImage,
            token: generateToken(user._id),
        });
    } catch (error) {
        console.error(error.message);
        return res.status(500).json({ message: error.message });
    }
});



const Login = AsyncHandler(async (req, res) => {
    const { email, password } = req.body;
    if (!email || !password) {
        return res.status(400).json({ message: "Please fill required fields" });
    }
    const user = await User.findOne({ email });
    if (user && await bcrypt.compare(password, user.password)) {
        return res.status(200).json({
            _id: user._id,
            fullName: user.fullName,
            mobileNumber: user.mobileNumber,
            email: user.email,
            profileImage: user.profileImage,
            token: generateToken(user._id),
            message: "Login successful"
        });
    } else {
        return res.status(401).json({ message: "Invalid email or password" });
    }
});



module.exports = { Signup, Login, forgotPassword,verifyOTP, resetPassword };
