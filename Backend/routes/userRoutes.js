const express = require("express");
const router = express.Router();
const {Signup, Login,forgotPassword,verifyOTP, resetPassword} = require("../controllers/userController");

router.route("/signup").post(Signup);
router.route("/login").post(Login);
router.route("/forgotpassword").post(forgotPassword);
router.route("/verifyotp").post(verifyOTP);
router.route("/resetpassword").post(resetPassword);

module.exports = router