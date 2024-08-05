const express = require("express");
const router = express.Router();
const {getReviews, postReview, updateReviews, deleteReviews} = require("../controllers/reviewController");


router.route("/").
get(getReviews).
post(postReview).
put(updateReviews).
delete(deleteReviews);

module.exports = router;